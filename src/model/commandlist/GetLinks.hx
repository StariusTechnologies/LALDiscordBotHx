package model.commandlist;

import discordhx.message.Message;
import utils.DiscordUtils;
import translations.LangCenter;
import model.entity.Link;

class GetLinks implements ICommandDefinition {
    public var paramsUsage = '';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;
    private var _outputs: Array<String>;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.getlinks.description');
    }

    public function process(args: Array<String>): Void {
        Entity.getAll(Link, function(links: Array<Link>): Void {
            if (links.length > 0) {
                var output = LangCenter.instance.translate(
                    DiscordUtils.getServerIdFromMessage(_context.getMessage()),
                    'model.commandlist.getlinks.process.introduction'
                );

                var linksOutput: String = links.map(function (link: Link): String {
                    return link.name;
                }).join(', ');

                output += '\n' + linksOutput;

                _outputs = DiscordUtils.splitLongMessage(output);
                sendOutput(0);
            } else {
                _context.sendToChannel('model.commandlist.getlinks.process.empty');
            }
        });
    }

    private function sendOutput(index: Int): Void {
        _context.rawSendToAuthor(_outputs[index], function (err: Dynamic, msg: Message): Void {
            if (index >= _outputs.length - 1) {
                _context.sendToChannel('model.commandlist.getlinks.sendoutput.channel_message', cast [_context.getMessage().author]);
            } else {
                sendOutput(index + 1);
            }
        });
    }
}
