Repository for all major Sacred 2 mods global.res localization.

Attempt to fix redundancy of multiple people working on the same spelling mistake fixes
as well as increasing overview of global.res
and simplify the modding process
by introducing mod inheritance.

The point of this is to (manually) propagate spelling mistake fixes down the tree.
To help with that, changes and small changes get distinguished and sorted automatically.

The function to compare strings however is not yet perfect.

\_\_BASE\_\_ contains PFP locale since i figured that would be the best candidate for it, but i guess the contents will start to differ over time.
All other mods must inherit from another mod.
Inherited mods have four files per language:

- adds: hashes which aren't present in ancestor mod
- smallChanges: potential spelling mistake corections which, if they are, should get propagated down to ancestor mod.
- changes: hashes which are both present in ancestor and child mod but whee the text differs by more than a couple of characters
- removes: hashes which are present in ancestor mod but not in child mod

New Mods can easily get added with Decompose.exe (and Reassemble.exe builds the global.res from the decoded files).

WIP: First successful Decompose has been accomplished but the Reassembling process is yet to be implemented.


Decompose.exe: Add new mod, DECODE it & decompose it by implementing the mod inheritance
Compose.exe: ENCODE one of the mods to update the changes