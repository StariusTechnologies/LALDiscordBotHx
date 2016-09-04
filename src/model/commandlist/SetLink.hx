package model.commandlist;

import model.entity.Link;
import utils.DiscordUtils;
import StringTools;
import translations.LangCenter;

class SetLink implements ICommandDefinition {
    public var paramsUsage = '(name) (link)';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.setlink.description');
    }

    public function process(args: Array<String>): Void {
        var author = _context.getMessage().author;

        if (args.length > 1) {
            var name: String = StringTools.trim(args.shift());
            var content: String = StringTools.trim(args.join(' '));
            var link: Link = new Link();
            var uniqueValues: Map<String, String> = new Map<String, String>();

            uniqueValues.set('name', name);

            link.retrieve(uniqueValues, function (found: Bool): Void {
                if (!found) {
                    link.name = name;
                }

                link.content = content;

                link.save(function (err: Dynamic) {
                    if (err != null) {
                        _context.sendToChannel('model.commandlist.setlink.process.fail', cast [author, err]);
                    } else {
                        _context.sendToChannel('model.commandlist.setlink.process.success', cast [author]);
                    }
                });
            });
        } else {
            _context.sendToChannel('model.commandlist.setlink.process.wrong_format', cast [author]);
        }
    }
}
