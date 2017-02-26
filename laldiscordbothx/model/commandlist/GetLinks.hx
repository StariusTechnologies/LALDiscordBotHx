package laldiscordbothx.model.commandlist;

import discordbothx.service.DiscordUtils;
import discordbothx.core.CommunicationContext;
import discordhx.message.Message;
import laldiscordbothx.model.entity.Link;

class GetLinks extends LALBaseCommand {
    private var outputs: Array<String>;

    public function new(context: CommunicationContext) {
        super(context);
    }

    override public function process(args: Array<String>): Void {
        Entity.getAll(Link, function(links: Array<Link>): Void {
            if (links.length > 0) {
                var output = l('introduction');

                var linksOutput: String = links.map(function (link: Link): String {
                    return link.name;
                }).join(', ');

                output += '\n' + linksOutput;

                context.sendToAuthor(output, cast {split: true}).then(function (message: Message): Void {
                    context.sendToChannel(l('channel_message', cast [context.message.author]));
                });
            } else {
                context.sendToChannel(l('empty'));
            }
        });
    }
}
