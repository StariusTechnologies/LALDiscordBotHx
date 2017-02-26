package laldiscordbothx.model.commandlist;

import discordbothx.core.CommunicationContext;
import laldiscordbothx.model.entity.Link;

class SetLink extends LALBaseCommand {
    public function new(context: CommunicationContext) {
        super(context);

        nbRequiredParams = 2;
        paramsUsage = '(name) (link)';
    }

    override public function process(args: Array<String>): Void {
        var author = context.message.author;

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
                        context.sendToChannel(l('fail', cast [author, err]));
                    } else {
                        context.sendToChannel(l('success', cast [author]));
                    }
                });
            });
        } else {
            context.sendToChannel(l('wrong_format', cast [author]));
        }
    }
}
