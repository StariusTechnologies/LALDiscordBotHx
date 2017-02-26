package laldiscordbothx.model.commandlist;

import discordbothx.core.CommunicationContext;
import laldiscordbothx.model.entity.Link as LinkEntity;

class Link extends LALBaseCommand {
    public function new(context: CommunicationContext) {
        super(context);

        nbRequiredParams = 1;
        paramsUsage = '(name)';
    }

    override public function process(args: Array<String>): Void {
        var author = context.message.author;

        if (args.length > 0) {
            var name: String = StringTools.trim(args[0]);
            var link: LinkEntity = new LinkEntity();
            var uniqueValues: Map<String, String> = new Map<String, String>();

            uniqueValues.set('name', name);

            link.retrieve(uniqueValues, function(found) {
                if (found) {
                    context.sendToChannel(link.content);
                } else {
                    context.sendToChannel(l('not_found', cast [author]));
                }
            });
        } else {
            context.sendToChannel(l('parse_error', cast [author]));
        }
    }
}
