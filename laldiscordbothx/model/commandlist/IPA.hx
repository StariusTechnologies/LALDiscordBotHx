package laldiscordbothx.model.commandlist;

import discordbothx.log.Logger;
import discordbothx.core.CommunicationContext;

class IPA extends LALBaseCommand {
    public function new(context: CommunicationContext) {
        super(context);

        nbRequiredParams = 1;
        paramsUsage = '(X-SAMPA)';
    }

    override public function process(args: Array<String>): Void {
        if (args.length > 0 && args[0].length > 0) {
            var replacementMap:Map<String, Array<Int>> = getReplacementMap();
            var keys = replacementMap.keys();
            var originalString = args.join(' ');
            var transcriptedString = '';
            var nextCharacter = false;

            while (originalString.length > 0) {
                var chunkOffset = 0;
                var found = false;

                while (chunkOffset < originalString.length && !found) {
                    var chunk = originalString.substr(chunkOffset);
                    Logger.info('Searching for match... Current offset is "' + chunkOffset + '".');

                    if (replacementMap.exists(chunk)) {
                        var match = replacementMap.get(chunk);
                        var transcriptedChunk = '';
                        Logger.info('Found replacement for "' + chunk + '"!');

                        found = true;

                        for (characterCode in match) {
                            transcriptedChunk += String.fromCharCode(characterCode);
                        }

                        transcriptedString = transcriptedChunk + transcriptedString;
                        originalString = originalString.substr(0, chunkOffset);
                    } else if (chunk.length == 1) {
                        Logger.info('Did not find replacement for "' + chunk + '"...');

                        if (chunk != '-') {
                            transcriptedString = chunk + transcriptedString;
                        }

                        originalString = originalString.substr(0, chunkOffset);
                    }

                    chunkOffset++;
                }
            }

            context.sendToChannel(context.message.author + ', ' + transcriptedString);
        } else {
            context.sendToChannel(l('fail', cast [context.message.author]));
        }
    }

    private function getReplacementMap():Map<String, Array<Int>> {

        var replacementMap = new Map<String, Array<Int>>();

        replacementMap.set('1', [616]);
        replacementMap.set('2', [248]);
        replacementMap.set('3', [604]);
        replacementMap.set('4', [638]);
        replacementMap.set('5', [619]);
        replacementMap.set('6', [592]);
        replacementMap.set('7', [612]);
        replacementMap.set('8', [629]);
        replacementMap.set('9', [339]);
        replacementMap.set('a', [97]);
        replacementMap.set('b', [98]);
        replacementMap.set('b_<', [595]);
        replacementMap.set('c', [99]);
        replacementMap.set('d', [100]);
        replacementMap.set('dK\\', [100, 865, 622]);
        replacementMap.set('dz', [100, 865, 122]);
        replacementMap.set('dz\\', [100, 865, 657]);
        replacementMap.set('dZ', [100, 865, 658]);
        replacementMap.set('d`', [598]);
        replacementMap.set('d`z`', [598, 865, 656]);
        replacementMap.set('d_<', [599]);
        replacementMap.set('e', [101]);
        replacementMap.set('f', [102]);
        replacementMap.set('g', [609]);
        replacementMap.set('gb', [103, 865, 98]);
        replacementMap.set('g_<', [608]);
        replacementMap.set('h', [104]);
        replacementMap.set('h\\', [614]);
        replacementMap.set('i', [105]);
        replacementMap.set('j', [106]);
        replacementMap.set('j\\', [669]);
        replacementMap.set('k', [107]);
        replacementMap.set('kp', [107, 865, 112]);
        replacementMap.set('l', [108]);
        replacementMap.set('l`', [621]);
        replacementMap.set('l\\', [634]);
        replacementMap.set('m', [109]);
        replacementMap.set('n', [110]);
        replacementMap.set('Nm', [331, 865, 109]);
        replacementMap.set('n`', [627]);
        replacementMap.set('o', [111]);
        replacementMap.set('p', [112]);
        replacementMap.set('p\\', [632]);
        replacementMap.set('q', [113]);
        replacementMap.set('r', [114]);
        replacementMap.set('r`', [637]);
        replacementMap.set('r\\', [633]);
        replacementMap.set('r\\`', [635]);
        replacementMap.set('s', [115]);
        replacementMap.set('s`', [642]);
        replacementMap.set('s\\', [597]);
        replacementMap.set('t', [116]);
        replacementMap.set('tK', [116, 865, 620]);
        replacementMap.set('ts', [116, 865, 115]);
        replacementMap.set('ts\\', [116, 865, 597]);
        replacementMap.set('tS', [116, 865, 643]);
        replacementMap.set('t`', [648]);
        replacementMap.set('t`s`', [648, 865, 642]);
        replacementMap.set('u', [117]);
        replacementMap.set('v', [118]);
        replacementMap.set('w', [119]);
        replacementMap.set('x', [120]);
        replacementMap.set('x\\', [615]);
        replacementMap.set('y', [121]);
        replacementMap.set('z', [122]);
        replacementMap.set('z`', [656]);
        replacementMap.set('z\\', [657]);
        replacementMap.set('A', [593]);
        replacementMap.set('B', [946]);
        replacementMap.set('B\\', [665]);
        replacementMap.set('C', [231]);
        replacementMap.set('D', [240]);
        replacementMap.set('E', [603]);
        replacementMap.set('F', [625]);
        replacementMap.set('G', [611]);
        replacementMap.set('G\\', [610]);
        replacementMap.set('G\\_<', [667]);
        replacementMap.set('H', [613]);
        replacementMap.set('H\\', [668]);
        replacementMap.set('I', [618]);
        replacementMap.set('I\\', [7547]);
        replacementMap.set('J', [626]);
        replacementMap.set('J\\', [607]);
        replacementMap.set('J\\_<', [644]);
        replacementMap.set('K', [620]);
        replacementMap.set('K\\', [622]);
        replacementMap.set('L', [654]);
        replacementMap.set('L\\', [671]);
        replacementMap.set('M', [623]);
        replacementMap.set('M\\', [624]);
        replacementMap.set('N', [331]);
        replacementMap.set('N\\', [628]);
        replacementMap.set('O', [596]);
        replacementMap.set('O\\', [664]);
        replacementMap.set('P', [651]);
        replacementMap.set('Q', [594]);
        replacementMap.set('R', [641]);
        replacementMap.set('R\\', [640]);
        replacementMap.set('S', [643]);
        replacementMap.set('T', [952]);
        replacementMap.set('U', [650]);
        replacementMap.set('U\\', [7551]);
        replacementMap.set('V', [652]);
        replacementMap.set('W', [653]);
        replacementMap.set('X', [967]);
        replacementMap.set('X\\', [295]);
        replacementMap.set('Y', [655]);
        replacementMap.set('Z', [658]);
        replacementMap.set('.', [46]);
        replacementMap.set('"', [712]);
        replacementMap.set('%', [716]);
        replacementMap.set(':', [720]);
        replacementMap.set(':\\', [721]);
        replacementMap.set('--', [45]);
        replacementMap.set('@', [601]);
        replacementMap.set('@\\', [600]);
        replacementMap.set('{', [230]);
        replacementMap.set('}', [649]);
        replacementMap.set(')', [865]);
        replacementMap.set('3\\', [606]);
        replacementMap.set('&', [630]);
        replacementMap.set('?', [660]);
        replacementMap.set('?\\', [661]);
        replacementMap.set('*', [42]);
        replacementMap.set('/', [47]);
        replacementMap.set('<', [60]);
        replacementMap.set('<\\', [674]);
        replacementMap.set('>', [62]);
        replacementMap.set('>\\', [673]);
        replacementMap.set('^', [8593]);
        replacementMap.set('!', [8595]);
        replacementMap.set('!\\', [451]);
        replacementMap.set('|', [124]);
        replacementMap.set('|\\', [448]);
        replacementMap.set('|\\|\\', [449]);
        replacementMap.set('||', [124, 124]);
        replacementMap.set('=\\', [450]);
        replacementMap.set('-\\', [8255]);
        replacementMap.set('_"', [776]);
        replacementMap.set('_+', [799]);
        replacementMap.set('_-', [800]);
        replacementMap.set('_/', [711]);
        replacementMap.set('_0', [805]);
        replacementMap.set('_<', [95, 60]);
        replacementMap.set('_=', [809]);
        replacementMap.set('_>', [700]);
        replacementMap.set('_?\\', [740]);
        replacementMap.set('_\\', [710]);
        replacementMap.set('_^', [815]);
        replacementMap.set('_}', [794]);
        replacementMap.set('`', [734]);
        replacementMap.set('_~', [771]);
        replacementMap.set('_A', [792]);
        replacementMap.set('_a', [826]);
        replacementMap.set('_B', [783]);
        replacementMap.set('_B_L', [95, 66, 95, 76]);
        replacementMap.set('_c', [796]);
        replacementMap.set('_d', [810]);
        replacementMap.set('_e', [820]);
        replacementMap.set('<F>', [60, 70, 62]);
        replacementMap.set('_F', [770]);
        replacementMap.set('_G', [736]);
        replacementMap.set('_H', [769]);
        replacementMap.set('_H_T', [95, 72, 95, 84]);
        replacementMap.set('_h', [688]);
        replacementMap.set('_j', [690]);
        replacementMap.set('_k', [816]);
        replacementMap.set('_L', [768]);
        replacementMap.set('_l', [737]);
        replacementMap.set('_M', [772]);
        replacementMap.set('_m', [827]);
        replacementMap.set('_N', [828]);
        replacementMap.set('_n', [8319]);
        replacementMap.set('_O', [825]);
        replacementMap.set('_o', [798]);
        replacementMap.set('_q', [793]);
        replacementMap.set('<R>', [60, 82, 62]);
        replacementMap.set('_R', [780]);
        replacementMap.set('_R_F', [95, 82, 95, 70]);
        replacementMap.set('_r', [797]);
        replacementMap.set('_T', [779]);
        replacementMap.set('_t', [804]);
        replacementMap.set('_v', [812]);
        replacementMap.set('_w', [695]);
        replacementMap.set('_X', [774]);
        replacementMap.set('_x', [829]);

        return replacementMap;
    }
}
