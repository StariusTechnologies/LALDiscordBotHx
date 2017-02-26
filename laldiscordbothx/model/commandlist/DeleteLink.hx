package laldiscordbothx.model.commandlist;

import discordbothx.core.CommunicationContext;
import laldiscordbothx.model.entity.Link;
import StringTools;

class DeleteLink extends LALBaseCommand {
    public function new(context: CommunicationContext) {
        super(context);

        nbRequiredParams = 1;
        paramsUsage = '(name)';
    }

    override public function process(args: Array<String>): Void {
        var author = context.message.author;

        if (args.length > 0) {
            var name: String = StringTools.trim(args.shift());
            var link: Link = new Link();
            var uniqueValues: Map<String, String> = new Map<String, String>();

            uniqueValues.set('name', name);

            link.retrieve(uniqueValues, function (found: Bool): Void {
                if (found) {
                    link.remove(function (err: Dynamic) {
                        if (err != null) {
                            context.sendToChannel(l('fail', cast [author, err]));
                        } else {
                            context.sendToChannel(l('success', cast [author]));
                        }
                    });
                } else {
                    context.sendToChannel(l('not_found', cast [author]));
                }
            });
        } else {
            context.sendToChannel(l('wrong_format', cast [author]));
        }
    }
}
