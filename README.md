Repository for all major Sacred 2 mods global.res localization.

Attempt to fix redundancy of multiple people working on the same spelling mistake fixes
as well as increasing overview of global.res
and simplify the modding process
by introducing mod inheritance.

"__BASE__" contains PFP locale.
All other mods must inherit from another mod.
Inherited mods have four files per language:

- adds: hashes which aren't present in ancestor mod
- smallChanges: potential spelling mistake corections which, if they are, should get propagated down to ancestor mod.
- changes: hashes which are both present in ancestor and child mod but whee the text differs by more than a couple of characters
- removes: hashes which are present in ancestor mod but not in child mod

New Mods can easily get added with Decompose.exe (and Reassemble.exe builds the global.res from the decoded files).

WIP: First successful Decompose has been accomplished but the Reassembling process is yet to be implemented.