#include <string.h>
#include "matcher.h"

/**
 * Implementation of your matcher function, which
 * will be called by the main program.
 *
 * You may assume that both line and pattern point
 * to reasonably short, null-terminated strings.
 * Rgrep specs...
 *  * - match character any number of times.
 *  . - match any character
 *  \ - escape char.
 */


/* dectect speical chars. */
int isSpecial(char c) {
    return c == '.' || c == '*' || c == '\\';
}

int matcher(int lnPos, int patPos, int maxLn, int maxPat);

char *ln;
char *pat;
int rgrep_matches(char *line, char *pattern) {
    pat = pattern;
    ln = line;
    return matcher(0, 0, strlen(line), strlen(pattern));
}


int matcher(int lnPos, int patPos, int maxLn, int maxPat) {
    // We've exceeded the limit of either the line or the pattern.
    if (lnPos >= maxLn && patPos < maxPat) { // chars left in pattern. ???
        if (pat[patPos] == '*') {
            return matcher(lnPos - 1, patPos + 1, maxLn, maxPat);
        } else {
            return 0;
        }
    } else if (patPos >= maxPat && lnPos < maxLn) { // finished the pattern
        return 1;
    } else if (lnPos >= maxLn && patPos >= maxPat) { // finished both
        return 1;
    } else if (pat[patPos] == '*') { // \* doesn't work here...
        if (pat[patPos - 1] == ln[lnPos] && pat[patPos - 1] != '\\') {
            return matcher(lnPos + 1, patPos, maxLn, maxPat) || \
                matcher(lnPos - 1, patPos + 1, maxLn, maxPat) || \
                matcher(lnPos - 1, patPos, maxLn, maxPat) || \
                matcher(lnPos, patPos + 1, maxLn, maxPat);
            // this is a really hacky problem for a*a.
        } else {
            return matcher(0, patPos + 1, maxLn, maxPat);
        }
    } else if (pat[patPos] == '\\') {
        if (pat[patPos + 1] == ln[lnPos]) {
            return matcher(lnPos + 1, patPos + 1, maxLn, maxPat);
        } else {
            return matcher(lnPos + 1, patPos, maxLn, maxPat);
        }
    } else if (ln[lnPos] == pat[patPos] || pat[patPos] == '.') { // correct.
        return matcher(lnPos + 1, patPos + 1, maxLn, maxPat);
    } else {
        return matcher(lnPos + 1, patPos, maxLn, maxPat);
    }
}
