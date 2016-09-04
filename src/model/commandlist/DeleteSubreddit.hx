package model.commandlist;

import model.entity.Subreddit;
import model.entity.Link;
import utils.DiscordUtils;
import StringTools;
import translations.LangCenter;

class DeleteSubreddit implements ICommandDefinition {
    public var paramsUsage = '(name)';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.deletesubreddit.description');
    }

    public function process(args: Array<String>): Void {
        var author = _context.getMessage().author;

        if (args.length > 0) {
            var name: String = StringTools.trim(args[0]);
            var subreddit: Subreddit = new Subreddit();
            var uniqueValues: Map<String, String> = new Map<String, String>();

            uniqueValues.set('name', name);

            subreddit.retrieve(uniqueValues, function (found: Bool): Void {
                if (found) {
                    subreddit.remove(function (err: Dynamic) {
                        if (err != null) {
                            _context.sendToChannel('model.commandlist.deletesubreddit.process.fail', cast [author, err]);
                        } else {
                            _context.sendToChannel('model.commandlist.deletesubreddit.process.success', cast [author]);
                            IntervalHandler.instance.refreshIntervalList();
                        }
                    });
                } else {
                    _context.sendToChannel('model.commandlist.deletesubreddit.process.not_found', cast [author]);
                }
            });
        } else {
            _context.sendToChannel('model.commandlist.deletesubreddit.process.wrong_format', cast [author]);
        }
    }
}
