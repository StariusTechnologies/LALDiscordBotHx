package model.commandlist;

import utils.DiscordUtils;
import translations.LangCenter;
import model.entity.Link as LinkEntity;

class Link implements ICommandDefinition {
    public var paramsUsage = '(name)';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.link.description');
    }

    public function process(args: Array<String>): Void {
        var author = _context.getMessage().author;

        if (args.length > 0) {
            var name: String = StringTools.trim(args[0]);
            var link: LinkEntity = new LinkEntity();
            var uniqueValues: Map<String, String> = new Map<String, String>();

            uniqueValues.set('name', name);

            link.retrieve(uniqueValues, function(found) {
                if (found) {
                    _context.rawSendToChannel(link.content);
                } else {
                    _context.sendToChannel('model.commandlist.link.process.not_found', cast [author]);
                }
            });
        } else {
            _context.sendToChannel('model.commandlist.link.process.parse_error', cast [author]);
        }
    }
}
