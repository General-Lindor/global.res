--https://en.wikipedia.org/wiki/Longest_common_substring
--I did some improvements; should be O(n+m) now!
--And don't even need complicated stuff like suffix Tree!
function longestCommonSubstrings(stringA, stringB)
    local lengthA = stringA:len()
    local lengthB = stringB:len()
    
    local previous
    local current = {}
    
    local LCSlength = 0
    local indexEnds = {}
    
    local get
    local store
    
    do
        get = function(j)
            local possibleResult = previous[j]
            if (possibleResult == nil) then
                do return 0 end
            end
            do return possibleResult end
        end
    end
    
    do
        store = function(i, j)
            local value = (get(j - 1) + 1)
            do current[j] = value end
            if (value == LCSlength) then
                do table.insert(indexEnds, {j, i}) end
            elseif (value > LCSlength) then
                do LCSlength = value end
                do indexEnds = {{j, i}} end
            end
        end
    end
    
    local lettersA = {}
    
    for indexA = 1, lengthA, 1 do
        local letter = stringA:sub(indexA, (indexA))
        local t = lettersA[letter]
        if (t == nil) then
            do lettersA[letter] = {indexA} end
        else
            do table.insert(t, indexA) end
        end
    end
    
    for indexB = 1, lengthB, 1 do
        do previous = current end
        do current = {} end
        local letter = stringB:sub(indexB, (indexB))
        local t = lettersA[letter]
        if (t ~= nil) then
            for key, indexA in ipairs(t) do
                do store(indexB, indexA) end
            end
        end
    end
    
    do return indexEnds, LCSlength end
end

--returns the count of difference letters between two strings as an integer value
function string:slowCompareByLCS(otherString)
    
    if self == otherString then
        do return 0 end
    end

    local sizeSelf = self:len()
    local sizeOtherString = otherString:len()
    
    local result
    local indexEnds, longestCommonSubstringLength = longestCommonSubstrings(self, otherString)
    if (longestCommonSubstringLength == 0) then
        do result = sizeSelf + sizeOtherString end
    else
        for key, indexPair in pairs(indexEnds) do
            local indexSelfEnd = indexPair[1]
            local indexOtherStringEnd = indexPair[2]
            
            local indexSelfStart = ((indexSelfEnd - longestCommonSubstringLength) + 1)
            local indexOtherStringStart = ((indexOtherStringEnd - longestCommonSubstringLength) + 1)
            
            local selfLeft = self:sub(1, (indexSelfStart - 1))
            local otherStringLeft = otherString:sub(1, (indexOtherStringStart - 1))
            
            local selfRight = self:sub((indexSelfEnd + 1), sizeSelf)
            local otherStringRight = otherString:sub((indexOtherStringEnd + 1), sizeOtherString)
            
            local resultLeft = (selfLeft:slowCompare(otherStringLeft))
            local resultRight = (selfRight:slowCompare(otherStringRight))
            
            local currentResult = resultLeft + resultRight
            if (result == nil) then
                do result = currentResult end
            else
                do result = math.min(result, currentResult) end
            end
        end
    end
    
    do return result end
end

--https://en.wikipedia.org/wiki/Longest_common_substring
--I did some improvements; should be O(n+m) now!
--And don't even need complicated stuff like suffix Tree!
function firstLongestCommonSubstring(stringA, stringB)
    local lengthA = stringA:len()
    local lengthB = stringB:len()
    
    local previous
    local current = {}
    
    local LCSlength = 0
    local indexAEnd
    local indexBEnd
    
    local get
    local store
    
    do
        get = function(j)
            local possibleResult = previous[j]
            if (possibleResult == nil) then
                do return 0 end
            end
            do return possibleResult end
        end
    end
    
    do
        store = function(i, j)
            local value = (get(j - 1) + 1)
            do current[j] = value end
            if (value > LCSlength) then
                do LCSlength = value end
                do indexAEnd = j end
                do indexBEnd = i end
            end
        end
    end
    
    local lettersA = {}
    
    for indexA = 1, lengthA, 1 do
        local letter = stringA:sub(indexA, (indexA))
        local t = lettersA[letter]
        if (t == nil) then
            do lettersA[letter] = {indexA} end
        else
            do table.insert(t, indexA) end
        end
    end
    
    for indexB = 1, lengthB, 1 do
        do previous = current end
        do current = {} end
        local letter = stringB:sub(indexB, (indexB))
        local t = lettersA[letter]
        if (t ~= nil) then
            for key, indexA in ipairs(t) do
                do store(indexB, indexA) end
            end
        end
    end
    
    do return indexAEnd, indexBEnd, LCSlength end
end

--returns the count of difference letters between two strings as an integer value
function string:compareByLCS(otherString)
    
    if self == otherString then
        do return 0 end
    end

    local sizeSelf = self:len()
    local sizeOtherString = otherString:len()
    
    local indexSelfEnd, indexOtherStringEnd, longestCommonSubstringLength = firstLongestCommonSubstring(self, otherString)
    if (longestCommonSubstringLength == 0) then
        do result = sizeSelf + sizeOtherString end
        do return result end
    end
    
    local indexSelfStart = ((indexSelfEnd - longestCommonSubstringLength) + 1)
    local indexOtherStringStart = ((indexOtherStringEnd - longestCommonSubstringLength) + 1)
    
    local selfLeft = self:sub(1, (indexSelfStart - 1))
    local otherStringLeft = otherString:sub(1, (indexOtherStringStart - 1))
    
    local selfRight = self:sub((indexSelfEnd + 1), sizeSelf)
    local otherStringRight = otherString:sub((indexOtherStringEnd + 1), sizeOtherString)
    
    local resultLeft = (selfLeft:compare(otherStringLeft))
    local resultRight = (selfRight:compare(otherStringRight))
    
    local result = resultLeft + resultRight
    do return result end
end

function string:levenshteinSlow(otherString)

    local L = {}
    
    local get
    local store
    
    do
        store = function(i, j, value)
            local t = L[i]
            if (t ~= nil) then
                do t[j] = value end
            else
                do L[i] = {value} end
            end
        end
    end
    
    do
        get = function(i, j)
            if (i == 0) then
                do return j end
            elseif (j == 0) then
                do return i end
            end
            
            local value = L[i]
            if (value ~= nil) then
                do value = value[j] end
                if (value ~= nil) then
                    do return value end
                end
            end
            
            local first = get(i - 1, j - 1)
            if self:sub(i, i) == self:sub(j, j) then
                do value = first end
            else
                local second = get(i, j - 1)
                local third = get(i - 1, j)
                do value = ((math.min(first, math.min(second, third))) + 1) end
            end
            do store(i, j, value) end
            do return value end
        end
    end
    
    local sizeSelf = self:len()
    local sizeOtherString = otherString:len()
    local result = get(sizeSelf, sizeOtherString)
    do return result end
end

--returns the count of difference letters between two strings as an integer value
function string:levenshtein(otherString)
    
    if self == otherString then
        do return 0 end
    end

    local sizeSelf = self:len()
    local sizeOtherString = otherString:len()
    
    local larger
    local smaller
    
    local sizeLarger
    local sizeSmaller
    
    if (sizeSelf > sizeOtherString) then
        do larger = self end
        do smaller = otherString end
        do sizeLarger = sizeSelf end
        do sizeSmaller = sizeOtherString end
    else
        do larger = otherString end
        do smaller = self end
        do sizeLarger = sizeOtherString end
        do sizeSmaller = sizeSelf end
    end
    local diff = (sizeLarger - sizeSmaller)
    
    local result = sizeLarger
    
    local letters = {}
    for i = 1, sizeLarger, 1 do
        do letters[i] = larger:sub(i, i) end
    end
    
    for j = 1, sizeSmaller, 1 do
        local currentLetter = smaller:sub(j, j)
        for i = j, (j + diff), 1 do
            if ((letters[i]) == currentLetter) then
                do result = result - 1 end
                do break end
            end
        end
    end
    
    do return result end
end

function string:prepare()
    local p = string.char(0x00)
    local result = ""
    for i = 1, self:len(), 1 do
        do result = result..(self:sub(i, i))..p end
    end
    do return result end
end


local a = "While I've encountered a fair share of disturbed individuals in my 14-year-long career at the Skullsberg Asylum, my current patient, Archaon Kirby, seems to be a hopeless case indeed. A former high-ranking Priest of Lumen of considerable wealth, he had developed an unhealthy habit of smoking narcotic spices, resulting in deteriorating mental faculty and an eventual state of severe paranoid delusion. At the time of being entrusted to our care, Kirby was already clinically insane. He now spends his time constantly raving about the End Times and some One-Eyed King, called Abishai, destined to rule them all. He also mumbles something about miniatures, about us all being chess pieces in a Great Game. My methods fail at treating the poor fellow, I've got to consult my peers in Thylysium... "
local b = "<AlignH Value=Center/><b><i>Study of Goblinoids</i></b><br><br><AlignH Value=Left/>The Goblinoid classification not only covers Goblins, but also Orcs and Ogres. Some (usually older) books on anatomy also refer to Kobolds and Trolls as Goblinoids, but this is obviously wrong.<br><br>Anatomically speaking, Goblinoids differ only insignificantly from Humanoids; every major anatomical characteristic is shared by both classes. The anatomical separation of Goblinoids and Humanoids is however not based on science, but rather on history. The famous anthropologist and naturalist Kyrilath was the first to classify every living being in Ancaria (published in \"Fauna Ancaria\"). His hatred of Orcs and Goblins was so intense that he couldn't bear the thought of belonging to the same class, so he simply created a new one. His classifications are still in use today and are accepted as true by many.<br><br>Eccentric chauvinisms aside, one can find a number of anatomical differences between both classes:<br><br>Goblinoid beings - just as Humanoids - possess a pair of arms and a pair of legs which are connected to the torso. The head (with two eyes, two ears, a nose, and a mouth) sits on the shoulders. They usually walk upright using their two legs.<br>If one takes a closer look, it becomes obvious that Goblinoid skulls are broader and more compact than Humanoid skulls. Their jaw is strong and prominent, their canines are long and thick. The neck tends to be short and much thicker than a Humanoid neck; sometimes the head seems to rest right on the shoulders with no neck visible at all. Goblinoid arms are very long when compared to legs and torso. Goblinoids also tend to be bow legged with outward pointing feet.<br><br>Shoulders are strong and muscular. Goblinoids are overall very brawny. To compensate for this added mass their bodies tend to be quite short. Goblinoids, especially Orcs, are physically well suited for fast and powerful movements; however, they do not cope well with longer stretches of physical exertion.<br><br>As mentioned earlier, Kobolds are not members of the Goblinoid class, but shall be described here anyway as they are often mentioned in this context.<br><br>Kobold anatomy is characterized by extreme disproportions. The head seems much too large for the body, the arms are long and thin, the legs short. The most prominent feature of a Kobold is the long, crooked nose. Many myths and legends have sprung up about this olfactory organ. In the southern desert regions dried and ground Kobold nose is still being used as a cure for certain \"male problems\". Because of this superstition Kobolds have become almost extinct there.<br>The weight of the Kobold head leads to a shortening of the spine which causes a chronic disease with an unfavorable prognosis called Kobold Back. Nearly all Kobolds from a certain age on suffer from this condition. Statistics claim that almost 26% of all Kobolds die of Kobold back. The numbers for heroes who die trying to perform heroics and the number of adventurers falling victim to their adventures are almost as high."
do print(a:levenshtein(b)) end
print("Done Comparing")
do a = a:prepare() end
do b = b:prepare() end
print("Ready for next")
do io.read() end

do os.execute("cls") end
do print(a:levenshtein(b)) end
print("Done Comparing")
local c = [[Aus verschiedenen Legenden der Artamark<br><br>Unsere Geschichte beginnt mit einem der langen, nicht enden wollenden Kriege vergangener Tage im Land der Artamark. Niemand erinnert sich ganz genau daran, aber die Legende darüber wird noch heute gern erzählt. Damals brachen häufig Kriege zwischen den alten Rassen aus, und das Land der Menschen, zwischen Nor Plat und Tyr Lysia gelegen, wurde so zum Schlachtfeld. Dieser eine Krieg war besonders lang und hart. Er kostete viele Leben, viele Dörfer und Städte wurden zerstört. Elfen, Orcs und Menschen kämpften mal als Eroberer, mal als Verteidiger der Artamark. Manche Leute sagen, dass während dieses Krieges sogar die Zwerge ihre Höhlen verließen, um zu kämpfen. Die Menschen hatten keine Chance gegen die fortschrittlichen Elfen, die wütenden Orks und die zähen Zwerge. Es musste schon ein Wunder geschehen, damit die Menschen diesen Krieg überlebten.<br><br>Während des Krieg vergaßen die Menschen alle inneren Zänkereien. Sie arbeiteten zusammen, um sich auf den Kampf vorzubereiten. So wurden auch die fähigsten Waffenschmiede der Menschen versammelt, um eine ultimative Waffe zu schaffen, die die Chancen ihrer Nation im Krieg verbessern sollte. In dieser Zeit war die Magie der Elfen so stark, dass diese jeden beliebigen Zauber eines menschlichen Magiers abwehren konnten. Diese neue Waffe durfte daher nicht auf Magie zurückgreifen. Auf der anderen Seite waren die handwerklichen Fähigkeiten der Zwergen ebenfalls so überlegen, dass ihre Rüstungen praktisch nicht durchdrungen werden konnten. Also sollte die neue Waffe in der Lage sein, jede Rüstung zu umgehen und das Ziel direkt zu treffen. Viel Zeit blieb den Menschen für ihre Wunderwaffe aber nicht mehr, denn den nächsten Angriff der Orks würden sie schon nicht mehr aufhalten können. Die neue Waffe musste unbedingt fertig sein, bevor die Orks losschlagen konnten.<br><br>Die besten Waffenschmiede der Artamark suchten sieben Tage nach einem Weg, eine solche Waffe zu schaffen. Sie probierten eine Idee nach der anderen aus und weigerten sich, auch nur für eine einzige Minute innezuhalten, weil jede Minute die letzte für ihr Land sein könnte. Aber ihre Bemühungen waren vergeblich, alle Prototypen, die sie schufen, waren nicht mächtig genug. Dann Verlies einer der jüngsten Meister enttäuscht die Schmiede. Draußen sah er den dunklen Himmel und wusste nicht, was er als nächstes tun sollte. Aus dem Gefühl, klein und hilflos zu sein, fing er an zu beten. Er betete zu allen Göttern, die er kannte, und flehte sogar die Erde unter seinen Füßen und den Himmel über seinem Kopf um Hilfe an. Er war so verzweifelt, dass er nichts als den schwarzen Himmel und leuchtenden Sternen bemerkte. Dann begann einer der Sterne, sich zu bewegen, als ob er seine Gebete beantworten wollte. Er bewegte sich schneller und schneller, und plötzlich fiel er vom Himmel und verschwand irgendwo in den Wäldern. Der Schmied hielt es für ein Zeichen der Götter, so lief er in den Wald und begab sich auf die Suche nach der Sternschnuppe. Nach einigen Stunden fand er sie. Aber es war weder ein Stern noch eine Sternschnuppe, sondern ein Stück Erz. Es war so dunkel wie die Nacht und so heiß wie Feuer. Ohne zu zögern nahm der junge Schmied den schweren Erzklumpen an sich, obwohl er sich dabei die Hände verbrannte. Mit letzter Kraft schleppte er ihn in die Schmiede.<br><br>Als er die Schmiede betrat, hatten alle Waffenmeister ihre Hämmer ruhen lassen und waren ratlos, traurig und enttäuscht. Als der junge Schmied zu ihnen kam und von der Hilfe der Götter berichtete, entschieden sie, dass dieses Stück Erz ihr letzter Versuch sein sollte. Da es nur ein kleiner Brocken Erz war, schmolzen sie ihn ein und vermischten das Metall mit dem Stahl ihrer Waffen. Die daraus resultierende Metall war fester und geschmeidiger als der übliche Stahl. Daraus schufen sie ein Schwert, dessen dunkle Klinge stark und scharf war. Sie nannten ihre Schöpfung den "Erlöser", weil es das Land der Artamark vom Krieg erlösen sollte.<br><br>Stolz präsentierten die Waffenschmiede den Erlöser dem König der Artamark. Während er die Waffe bewunderte, versuchte der König, das große und zweifellos mächtige Schwert anzuheben, aber er konnte es nicht im geringsten bewegen. Was dem Erlöser die Kraft verlieh, jede Rüstung zu zerschlagen und seine Feinde niederzustrecken, machte es auch sehr groß und schwer. Nur die am besten trainierten und ausgebildeten Krieger konnten diese Klinge in einem Kampf benutzen. Dieses Schwert zu führen war eine besondere Ehre, so dass alle Vasallen des Königs versuchten, die Waffe anzuheben und sie ein wenig zu schwingen. Doch alle, die das Schwert anzuheben vermochten, ließen es im nächsten Augenblick wieder fallen.<br><br>Da alle Adligen beim Versuch, den Erlöser anzuheben, versagt hatten, beschloß der König, einen Blick auf die einfachen Soldaten zu werfen. Die Offiziere wurden angewiesen, ihre Männer antreten zu lassen. Umgeben von seinen Wächtern schritt der König durch die Reihen und inspizierte jeder seiner Truppen, ob einer der Soldaten sich von den anderen unterschied. Plötzlich erschien ein Elf aus dem Nichts, der vermutlich Elfenmagie benutzte, um schnell und unmittelbar vor dem menschlichen König zu erscheinen. Er sprach einen Zauberspruch auf die Stelle, wo der König und seine Wachen standen. Die Absichten des Eindringlings waren klar - er kam, um den König zu ermorden und damit die letzte Hoffnung er Menschen auf den Sieg zu zerstören. Des Königs Wachen wurden von dem Bann gefesselt und konnten sich nicht bewegen. Sie konnten den Attentäter nicht rechtzeitig stoppen. In diesem Augenblick höchster Not Verlies einer der privaten Soldaten die Formation und stürzte sich auf den Attentäter. Noch bevor die Elf einen weiteren Zauber ausführen konnte, hob der Soldat sein Schwert und tötete den Eindringling. Dieser Soldat missachtete seine Befehle, doch so rettete er dem König das Leben.<br><br>Der König war dankbar und beschloss, mit dem tapferen Soldaten zu reden. "Wie ist dein Name?", fragte der König. "Mein Name ist Aarnum Richfield, mein Herr", antwortete der Soldat, während er vor dem König kniete. "Du hast die Befehle deines Vorgesetzten missachtet, Soldat Richfield. Warum?", Fragte der König, um den Soldaten zu testen. "Ich tat es, weil ich nicht meinem Vorgesetzten diene, sondern Euch und der Artamark", antwortete Aarnum ohne Zögern. Der König froh, solche Loyalität zu sehen. Er entschied, dass Aarnums Waffeneinsatz belohnt werden sollte. Da der König Verbündete im Adel und seine Leute Helden benötigten, beschloss er, den Soldaten in den Ritterstand zu erheben und ihm ein kleines Landgut zu schenken. Um seine Dankbarkeit sofort zu zeigen forderte der König Aarnums Schwert, um ihn sofort zum Ritter zu schlagen. Überraschenderweise gab der Soldat dem Königs kein einfaches Schwert, das typisch für die menschliche Armee war, sondern ein riesiges, alt aussehendes Schwert. Er behauptete, dieses Schwert sei ein Erbstück. Der König war überrascht, ein so großes und schweres Schwert bei einem einfachen Soldaten zu sehen. "Wer, wenn nicht er", dachte der König, und befahl, den Erlöser herbeizubringen. "Wenn du dieses Schwert heben kannst, wirst du zu einem edlen Ritter und Helden dieses Landes werden.", sagte er zu Aarnum. Der Krieger nahm das Schwert und hob es ohne jede Mühe. Es schien zu ihm zu passen...<br><br>Der Rest ist Geschichte. Drei Monate später war der Krieg vorbei. Den Menschen war es gelungen, das Land der Artamark zu verteidigen, und da er ein freundlicher Mensch und ein tapferer Krieger war, machte sich Aarnum einen guten Namen und bewies, dass sein Schwert den Name zu Recht trägt.<br><br>Leider war das Ende von Sir Richfield Aarnums Leben nicht so erfreulich wie seine jungen Tage. Seine Söhne, die seinen Name und das Land erben sollten, waren nichts anderes als eine große Quelle der Enttäuschung und Sorgen. Der eine war ein Luftikus, der andere ein bösartiger Intrigant, und keiner von ihnen war jemand, auf den Aarnum hätte stolz sein können. Kurz vor seinem Tod sagte Sir Richfield: "Ich will nur demjenigen mein Schwert überlassen, der die Artamark wirklich schützen will. Ich möchte, dass der Erlöser verdient, nicht vererbt wird." So ordnete er an, dass der Erlöser, dem König zurückgegeben werde, in der Hoffnung, dass der König dieses Schwert nur einem wahren Helden des Landes geben wird.<br><br>Der Erlöser lag viele Jahrzehnte in der königlichen Schatzkammer. Die Könige der Artamark wussten, dass ihr Volk besonderes Augenmerk auf denjenigen legen wird, der diese Waffe schwingen würde, also gaben sie das Schwert nicht leichtfertig fort.<br><br>Das Schwert erschien erst wieder in einer der dunkelsten Zeiten für die Artamark. Aber diesmal gab es weder Eindringlinge noch äußere Feinde. Die Kräfte, die das Land zerrissen, kamen aus dem Inneren. Die mächtigen Vasallen des Königs weigerten sich, den Befehlen des Königs zu gehorchen und lieferten sich fortlaufend Kämpfe. Der Bürgerkrieg löschte langsam, aber stetig die menschliche Rasse aus. Der König versuchte, die Adligen niederzuzwingen, aber seine Autorität war dafür zu gering und seine Armee zu klein. Er brauchte einen Verbündeten unter den Adligen. Zu dieser Zeit war der mächtigste seiner Vasallen ein gewisser Freiherr Johann DeMordrey, der Besitzer des Skook's Corner. Der Baron war mächtig genug, um es sich leisten zu können, den König völlig zu ignorieren. Er wollte Macht, und er hatte schon reichlich davon. Eines Tages fand der König heraus, dass einer der Barone seiner Armee befohlen hatte, die Hauptstadt Greifenburg zu belagern. Seine eigene Armee war zu klein, um eine Belagerung standzuhalten, also beschloss der König, Johann DeMordrey um Hilfe zu bitten. Wissend um Johanns Durst nach Macht und Ruhm bot der König ihm den Titel des Ersten Ritters und den Erlöser als Belohnung an. Am nächsten Tag sendete Johann DeMordrey seine Truppen aus, um die königlichen Armee zu unterstützen. Als die Schlacht vorüber war wurde der Baron der neue Besitzer des Erlösers. Dies war auch der letzte Tag, an dem der König der Artamark tatsächlich sein Land regierte.<br><br>In den folgenden Jahren endete der Bürgerkrieg. Aber nicht, weil der Frieden zu den Menschen kam. Es herrschte die Angst. Jeder fürchtete die eigentlichen Herrscher des Artamark. Nein, es war nicht der König, der nichts in diesen Tagen hätte tun könnten. Alle fürchteten Baron Johann DeMordrey. Er war so grausam und streng, dass das Volk ihn "Johann den Schrecklichen" nannte. Er duldete niemanden, der ihm im Wege stand. Seine Armee beendete sofort alle Aufstände. Es gab Gerüchte, dass Johann den Tod seiner Feinde genießen würde, indem er sie eigenhändig durch sein legendäres Schwert richte. Einige Leute begannen daher, das Schwert "Dunkler Richter" zu nennen, aber diejenigen, die sich an die Geschichte erinnerten, nannten es weiterhin den "Erlöser", da es nicht nur Dunkelheit, sondern auch Licht in das Land der Artamark gebracht hatte.<br><br>Zwanzig Jahre vergingen, und Johann der Schrecklichen wurde älter und konnte nicht mehr auf alle Ereignisse mit seiner sonst gewohnten Schnelligkeit reagieren. Die Aufstände wurden bald häufiger. Als der Baron die Nachricht über eine Rebellion im Westen erhielt befahl er seiner Armee, sich dorthin zu begeben. Wie immer führte er seine Soldaten selbst in den Kampf. Zum Glück für alle Menschen der Artamark wurde Freiherr Johann in der Schlacht nahe der Stadt Wargfels getötet.<br><br>Das Schicksal des Schwertes allerdings bleibt ungewiss. Manche Leute sagen, dass es in der Schlacht verloren ging und irgendwo im Land der Artamark gefunden werden kann. Andere nehmen an, dass einer der Soldaten es gefunden und nach dem Willen des legendären Sir Richfield an den König zurückgegeben hat. Manche Leute vermuten sogar, das legendäre Schwert sei irgendwo im Schloss der Familie DeMordrey versteckt...<br><br>Nun, der Erlöser, der sowohl Licht als auch Dunkelheit bedeutet, der benutzt wurde, um Leben zu retten und den Tod zu bringen, liegt irgendwo verborgen und wartet geduldig auf seinen neuen Besitzer. Nur die Zeit wird zeigen, welcher Kraft dieses Schwert das nächste Mal dienen wird.]]
local d = [[Aus verschiedenen Legenden der Artamark<br><br>Unsere Geschichte beginnt mit einem der langen, nicht enden wollenden Kriege vergangener Tage im Land der Artamark. Niemand erinnert sich ganz genau daran, aber die Legende darüber wird noch heute gern erzählt. Damals brachen häufig Kriege zwischen den alten Rassen aus, und das Land der Menschen, zwischen Nor Plat und Tyr Lysia gelegen, wurde so zum Schlachtfeld. Dieser eine Krieg war besonders lang und hart. Er kostete viele Leben, viele Dörfer und Städte wurden zerstört. Elfen, Orcs und Menschen kämpften mal als Eroberer, mal als Verteidiger der Artamark. Manche Leute sagen, daß während dieses Krieges sogar die Zwerge ihre Höhlen verließen, um zu kämpfen. Die Menschen hatten keine Chance gegen die fortschrittlichen Elfen, die wütenden Orks und die zähen Zwerge. Es mußte schon ein Wunder geschehen, damit die Menschen diesen Krieg überlebten.<br><br>Während des Krieg vergaßen die Menschen alle inneren Zänkereien. Sie arbeiteten zusammen, um sich auf den Kampf vorzubereiten. So wurden auch die fähigsten Waffenschmiede der Menschen versammelt, um eine ultimative Waffe zu schaffen, die die Chancen ihrer Nation im Krieg verbessern sollte. In dieser Zeit war die Magie der Elfen so stark, daß diese jeden beliebigen Zauber eines menschlichen Magiers abwehren konnten. Diese neue Waffe durfte daher nicht auf Magie zurückgreifen. Auf der anderen Seite waren die handwerklichen Fähigkeiten der Zwergen ebenfalls so überlegen, daß ihre Rüstungen praktisch nicht durchdrungen werden konnten. Also sollte die neue Waffe in der Lage sein, jede Rüstung zu umgehen und das Ziel direkt zu treffen. Viel Zeit blieb den Menschen für ihre Wunderwaffe aber nicht mehr, denn den nächsten Angriff der Orks würden sie schon nicht mehr aufhalten können. Die neue Waffe mußte unbedingt fertig sein, bevor die Orks losschlagen konnten.<br><br>Die besten Waffenschmiede der Artamark suchten sieben Tage nach einem Weg, eine solche Waffe zu schaffen. Sie probierten eine Idee nach der anderen aus und weigerten sich, auch nur für eine einzige Minute innezuhalten, weil jede Minute die letzte für ihr Land sein könnte. Aber ihre Bemühungen waren vergeblich, alle Prototypen, die sie schufen, waren nicht mächtig genug. Dann verließ einer der jüngsten Meister enttäuscht die Schmiede. Draußen sah er den dunklen Himmel und wußte nicht, was er als nächstes tun sollte. Aus dem Gefühl, klein und hilflos zu sein, fing er an zu beten. Er betete zu allen Göttern, die er kannte, und flehte sogar die Erde unter seinen Füßen und den Himmel über seinem Kopf um Hilfe an. Er war so verzweifelt, daß er nichts als den schwarzen Himmel und leuchtenden Sternen bemerkte. Dann begann einer der Sterne, sich zu bewegen, als ob er seine Gebete beantworten wollte. Er bewegte sich schneller und schneller, und plötzlich fiel er vom Himmel und verschwand irgendwo in den Wäldern. Der Schmied hielt es für ein Zeichen der Götter, so lief er in den Wald und begab sich auf die Suche nach der Sternschnuppe. Nach einigen Stunden fand er sie. Aber es war weder ein Stern noche eine Sternschnuppe, sondern ein Stück Erz. Es war so dunkel wie die Nacht und so heiß wie Feuer. Ohne zu zögern nahm der junge Schmied den schweren Erzklumpen an sich, obwohl er sich dabei die Hände verbrannte. Mit letzter Kraft schleppte er ihn in die Schmiede.<br><br>Als er die Schmiede betrat, hatten alle Waffenmeister ihre Hämmer ruhen lassen und waren ratlos, traurig und enttäuscht. Als der junge Schmied zu ihnen kam und von der Hilfe der Götter berichtete, entschieden sie, dass dieses Stück Erz ihr letzter Versuch sein sollte. Da es nur ein kleiner Brocken Erz war, schmolzen sie ihn ein und vermischten das Metall mit dem Stahl ihrer Waffen. Die daraus resultierende Metall war fester und geschmeidiger als der übliche Stahl. Daraus schufen sie ein Schwert, dessen dunkle Klinge stark und scharf war. Sie nannten ihre Schöpfung den "Erlöser", weil es das Land der Artamark vom Krieg erlösen sollte.<br><br>Stolz präsentierten die Waffenschmiede den Erlöser dem König der Artamark. Während er die Waffe bewunderte, versuchte der König, das große und zweifellos mächtige Schwert anzuheben, aber er konnte es nicht im geringsten bewegen. Was dem Erlöser die Kraft verlieh, jede Rüstung zu zerschlagen und seine Feinde niederzustrecken, machte es auch sehr groß und schwer. Nur die am besten trainierten und ausgebildeten Krieger konnten diese Klinge in einem Kampf benutzen. Dieses Schwert zu führen war eine besondere Ehre, so daß alle Vasallen des Königs versuchten, die Waffe anzuheben und sie ein wenig zu schwingen. Doch alle, die das Schwert anzuheben vermochten, ließen es im nächsten Augenblick wieder fallen.<br><br>Da alle Adligen beim Versuch, den Erlöser anzuheben, versagt hatten, beschloß der König, einen Blick auf die einfachen Soldaten zu werfen. Die Offiziere wurden angewiesen, ihre Männer antreten zu lassen. Umgeben von seinen Wächtern schritt der König durch die Reihen und inspizierte jeder seiner Truppen, ob einer der Soldaten sich von den anderen unterschied. Plötzlich erschien ein Elf aus dem Nichts, der vermutlich Elfenmagie benutzte, um schnell und unmittelbar vor dem menschlichen König zu erscheinen. Er sprach einen Zauberspruch auf die Stelle, wo der König und seine Wachen standen. Die Absichten des Eindringlings waren klar - er kam, um den König zu ermorden und damit die letzte Hoffnung er Menschen auf den Sieg zu zerstören. Des Königs Wachen wurden von dem Bann gefesselt und konnten sich nicht bewegen. Sie konnten den Attentäter nicht rechtzeitig stoppen. In diesem Augenblick höchster Not verließ einer der privaten Soldaten die Formation und stürzte sich auf den Attentäter. Noch bevor die Elf einen weiteren Zauber ausführen konnte, hob der Soldat sein Schwert und tötete den Eindringling. Dieser Soldat mißachtete seine Befehle, doch so rettete er dem König das Leben.<br><br>Der König war dankbar und beschloss, mit dem tapferen Soldaten zu reden. "Wie ist dein Name?", fragte der König. "Mein Name ist Aarnum Richfield, mein Herr", antwortete der Soldat, während er vor dem König kniete. "Du hast die Befehle deines Vorgesetzten mißachtet, Soldat Richfield. Warum?", Fragte der König, um den Soldaten zu testen. "Ich tat es, weil ich nicht meinem Vorgesetzten diene, sondern Euch und der Artamark", antwortete Aarnum ohne Zögern. Der König froh, solche Loyalität zu sehen. Er entschied, dass Aarnum's Waffeneinsatz belohnt werden sollte. Da der König Verbündete im Adel und seine Leute Helden benötigten, beschloss er, den Soldaten in den Ritterstand zu erheben und ihm ein kleines Landgut zu schenken. Um seine Dankbarkeit sofort zu zeigen forderte der König Aarnum's Schwert, um ihn sofort zum Ritter zu schlagen. Überraschenderweise gab der Soldat dem Königs kein einfaches Schwert, das typisch für die menschliche Armee war, sondern ein riesiges, alt aussehendes Schwert. Er behauptete, dieses Schwert sei ein Erbstück. Der König war überrascht, ein so großes und schweres Schwert bei einem einfachen Soldaten zu sehen. "Wer, wenn nicht er", dachte der König, und befahl, den Erlöser herbeizubringen. "Wenn du dieses Schwert heben kannst, wirst du zu einem edlen Ritter und Helden dieses Landes werden.", sagte er zu Aarnum. Der Krieger nahm das Schwert und hob es ohne jede Mühe. Es schien zu ihm zu passen...<br><br>Der Rest ist Geschichte. Drei Monate später war der Krieg vorbei. Den Menschen war es gelungen, das Land der Artamark zu verteidigen, und da er ein freundlicher Mensch und ein tapferer Krieger war, machte sich Aarnum einen guten Namen und bewies, daß sein Schwert den Name zu Recht trägt.<br><br>Leider war das Ende von Sir Richfield Aarnums Leben nicht so erfreulich wie seine jungen Tage. Seine Söhne, die seinen Name und das Land erben sollten, waren nichts anderes als eine große Quelle der Enttäuschung und Sorgen. Der eine war ein Luftikus, der andere ein bösartiger Intrigant, und keiner von ihnen war jemand, auf den Aarnum hätte stolz sein können. Kurz vor seinem Tod sagte Sir Richfield: "Ich will nur demjenigen mein Schwert überlassen, der die Artamark wirklich schützen will. Ich möchte, daß der Erlöser verdient, nicht vererbt wird." So ordnete er an, daß der Erlöser, dem König zurückgegeben werde, in der Hoffnung, dass der König dieses Schwert nur einem wahren Helden des Landes geben wird.<br><br>Der Erlöser lag viele Jahrzehnte in der königlichen Schatzkammer. Die Könige der Artamark wussten, dass ihr Volk besonderes Augenmerk auf denjenigen legen wird, der diese Waffe schwingen würde, also gaben sie das Schwert nicht leichtfertig fort.<br><br>Das Schwert erschien erst wieder in einer der dunkelsten Zeiten für die Artamark. Aber diesmal gab es weder Eindringlinge noch äußere Feinde. Die Kräfte, die das Land zerrissen, kamen aus dem Inneren. Die mächtigen Vasallen des Königs weigerten sich, den Befehlen des Königs zu gehorchen und lieferten sich fortlaufend Kämpfe. Der Bürgerkrieg löschte langsam, aber stetig die menschliche Rasse aus. Der König versuchte, die Adligen niederzuzwingen, aber seine Autorität war dafür zu gering und seine Armee zu klein. Er brauchte einen Verbündeten unter den Adligen. Zu dieser Zeit war der mächtigste seiner Vasallen ein gewisser Freiherr Johann DeMordrey, der Besitzer des Skook's Corner. Der Baron war mächtig genug, um es sich leisten zu können, den König völlig zu ignorieren. Er wollte Macht, und er hatte schon reichlich davon. Eines Tages fand der König heraus, daß einer der Barone seiner Armee befohlen hatte, die Hauptstadt Greifenburg zu belagern. Seine eigene Armee war zu klein, um eine Belagerung standzuhalten, also beschloss der König, Johann DeMordrey um Hilfe zu bitten. Wissend um Johanns Durst nach Macht und Ruhm bot der König ihm den Titel des Ersten Ritters und den Erlöser als Belohnung an. Am nächsten Tag sendete Johann DeMordrey seine Truppen aus, um die königlichen Armee zu unterstützen. Als die Schlacht vorüber war wurde der Baron der neue Besitzer des Erlösers. Dies war auch der letzte Tag, an dem der König der Artamark tatsächlich sein Land regierte.<br><br>In den folgenden Jahren endete der Bürgerkrieg. Aber nicht, weil der Frieden zu den Menschen kam. Es herrschte die Angst. Jeder fürchtete die eigentlichen Herrscher des Artamark. Nein, es war nicht der König, der nichts in diesen Tagen hätte tun könnten. Alle fürchteten Baron Johann DeMordrey. Er war so grausam und streng, dass das Volk ihn "Johann den Schrecklichen" nannte. Er duldete niemanden, der ihm im Wege stand. Seine Armee beendete sofort alle Aufstände. Es gab Gerüchte, daß Johann den Tod seiner Feinde geniessen würde, indem er sie eigenhändig durch sein legendäres Schwert richte. Einige Leute begannen daher, das Schwert "Dunkler Richter" zu nennen, aber diejenigen, die sich an die Geschichte erinnerten, nannten es weiterhin den "Erlöser", da es nicht nur Dunkelheit, sondern auch Licht in das Land der Artamark geracht hatte.<br><br>Zwanzig Jahre vergingen, und Johann der Schrecklichen wurde älter und konnte nicht mehr auf alle Ereignisse mit seiner sonst gewohnten Schnelligkeit reagieren. Die Aufstände wurden bald häufiger. Als der Baron die Nachricht über eine Rebellion im Westen erhielt befahl er seiner Armee, sich dorthin zu bewgeben. Wie immer führte er seine Soldaten selbst in den Kampf. Zum Glück für alle Menschen der Artamark wurde Freiherr Johann in der Schlacht nahe der Stadt Wargfels getötet.<br><br>Das Schicksal des Schwertes allerdings bleibt ungewiss. Manche Leute sagen, daß es in der Schlacht verloren ging und irgendwo im Land der Artamark gefunden werden kann. Andere nehmen an, daß einer der Soldaten es gefunden und nach dem Willen des legendären Sir Richfield an den König zurückgegeben hat. Manche Leute vermuten sogar, das legendäre Schwert sei irgendwo im Schloss der Familie DeMordrey versteckt...<br><br>Nun, der Erlöser, der sowohl Licht als auch Dunkelheit bedeutet, der benutzt wurde, um Leben zu retten und den Tod zu bringen, liegt irgendwo verborgen und wartet geduldig auf seinen neuen Besitzer. Nur die Zeit wird zeigen, welcher Kraft dieses Schwert das nächste Mal dienen wird.]]
print("Ready for next")
do io.read() end

do os.execute("cls") end
do print(c:levenshtein(d)) end
print("Done Comparing")
do c = c:prepare() end
do d = d:prepare() end
print("Ready for next")
do io.read() end

do os.execute("cls") end
do print(c:levenshtein(d)) end
print("Finally Done")
do io.read() end