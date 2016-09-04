package model.commandlist;

import haxe.Json;
import StringTools;
import utils.ArrayUtils;
import utils.DiscordUtils;
import nodejs.http.HTTP.HTTPMethod;
import utils.Logger;
import utils.HttpUtils;
import translations.LangCenter;

class Subreddit implements ICommandDefinition {
    public var paramsUsage = '(subreddit) *(sort by)*';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.subreddit.description');
    }

    public function process(args: Array<String>): Void {
        var author = _context.getMessage().author;

        if (args.length > 0) {
            var subreddit: String = args[0];
            var bestArray: Array<String> = new Array<String>();
            var path = '/r/' + subreddit + '/';

            bestArray.push('best');
            bestArray.push('top');
            bestArray.push('better');
            bestArray.push('hot');

            if (args.length > 1 && bestArray.indexOf(StringTools.trim(args[1])) > -1) {
                path += '.json?limit=';
            } else {
                path += 'new.json?limit=';
            }

            if (args.length > 2 && Std.parseInt(StringTools.trim(args[2])) > 0) {
                path += StringTools.trim(args[2]);
            } else {
                path += '5';
            }

            HttpUtils.query(true, 'www.reddit.com', path, cast HTTPMethod.Get, function (data: String) {
                var response: Dynamic = null;

                try {
                    response = Json.parse(data);
                } catch (err: Dynamic) {
                    Logger.exception(err);
                }

                if (response != null && Reflect.hasField(response, 'data') && Reflect.hasField(Reflect.field(response, 'data'), 'children')) {
                    var children: Array<Dynamic> = response.data.children;

                    children = children.filter(function (child: Dynamic): Bool {
                        return !child.data.stickied;
                    });

                    var message: String = '';

                    for (child in children) {
                        if (message.length > 0) {
                            message += '\n\n';
                        }

                        message += '`' + child.data.score + '` ' + child.data.title + ' | **' + child.data.author + '** | *' + child.data.num_comments + '* :speech_balloon: | <https://www.reddit.com' + child.data.permalink + '>';
                    }

                    _context.rawSendToChannel(message);
                    Core.instance.deleteMessage(_context.getMessage());
                } else {
                    Logger.error('Failed to load a subreddit feed (step 2)');
                    _context.sendToChannel('model.commandlist.subreddit.process.fail', cast [author]);
                }
            });
        } else {
            Logger.error('Failed to load a subreddit feed (step 1)');
            _context.sendToChannel('model.commandlist.subreddit.process.parse_error', cast [author]);
        }
    }
}
