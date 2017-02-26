package laldiscordbothx.model.commandlist;

import discordbothx.core.CommunicationContext;
import laldiscordbothx.translations.LangCenter;
import laldiscordbothx.utils.DiscordUtils;
import laldiscordbothx.utils.Humanify;
import laldiscordbothx.utils.ArrayUtils;

class Decide extends LALBaseCommand {
    public function new(context: CommunicationContext) {
        super(context);

        paramsUsage = '(thing) ' + l('split') + ' (other thing)';
        nbRequiredParams = 3;
    }

    override public function process(args: Array<String>): Void {
        var author = context.message.author;
        var idServer = DiscordUtils.getServerIdFromMessage(context.message);

        args = args.join(' ').split(' ' + l('split') + ' ');

        if (args.length > 1) {
            var picked = ArrayUtils.random(args);
            var sentence = LangCenter.instance.translate(idServer, Humanify.getChoiceDeliverySentence(), [picked]);

            context.sendToChannel(author + ', ' + sentence);
        } else {
            context.sendToChannel(l('wrong_format', cast [author]));
        }
    }

    override public function checkFormat(args: Array<String>): Bool {
        var parsedArgs: Array<String> = args.join(' ').split(' ' + l('split') + ' ');

        return super.checkFormat(args) && parsedArgs.length > 1;
    }
}
