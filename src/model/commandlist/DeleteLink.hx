package model.commandlist;

import model.entity.Link;
import utils.DiscordUtils;
import StringTools;
import translations.LangCenter;

class DeleteLink implements ICommandDefinition {
    public var paramsUsage = '(name)';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.deletelink.description');
    }

    public function process(args: Array<String>): Void {
        var author = _context.getMessage().author;

        if (args.length > 0) {
            var name: String = StringTools.trim(args.shift());
            var link: Link = new Link();
            var uniqueValues: Map<String, String> = new Map<String, String>();

            uniqueValues.set('name', name);

            link.retrieve(uniqueValues, function (found: Bool): Void {
                if (found) {
                    link.remove(function (err: Dynamic) {
                        if (err != null) {
                            _context.sendToChannel('model.commandlist.deletelink.process.fail', cast [author, err]);
                        } else {
                            _context.sendToChannel('model.commandlist.deletelink.process.success', cast [author]);
                        }
                    });
                } else {
                    _context.sendToChannel('model.commandlist.deletelink.process.not_found', cast [author]);
                }
            });
        } else {
            _context.sendToChannel('model.commandlist.deletelink.process.wrong_format', cast [author]);
        }
    }
}
