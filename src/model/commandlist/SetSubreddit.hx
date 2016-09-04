package model.commandlist;

import model.entity.Subreddit;
import utils.DiscordUtils;
import StringTools;
import translations.LangCenter;

class SetSubreddit implements ICommandDefinition {
    public var paramsUsage = '(name) (refresh interval)';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.setsubreddit.description');
    }

    public function process(args: Array<String>): Void {
        var author = _context.getMessage().author;

        if (args.length > 1) {
            var name: String = StringTools.trim(args[0]);
            var refreshInterval: Int = Std.parseInt(StringTools.trim(args[1]));
            var subreddit: Subreddit = new Subreddit();
            var uniqueValues: Map<String, String> = new Map<String, String>();

            uniqueValues.set('name', name);

            subreddit.retrieve(uniqueValues, function (found: Bool): Void {
                if (!found) {
                    subreddit.name = name;
                }

                subreddit.refreshInterval = refreshInterval;

                subreddit.save(function (err: Dynamic) {
                    if (err != null) {
                        _context.sendToChannel('model.commandlist.setsubreddit.process.fail', cast [author, err]);
                    } else {
                        _context.sendToChannel('model.commandlist.setsubreddit.process.success', cast [author]);
                        IntervalHandler.instance.refreshIntervalList();
                    }
                });
            });
        } else {
            _context.sendToChannel('model.commandlist.setsubreddit.process.wrong_format', cast [author]);
        }
    }
}
