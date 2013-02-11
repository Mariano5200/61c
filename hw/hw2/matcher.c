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

int matcher(char *ln, char *pat, int lnPos, int patPos, int maxLn, int maxPat);

int rgrep_matches(char *line, char *pattern) {
    return matcher(line, pattern, 0, 0, strlen(line), strlen(pattern));
}


int matcher(char *ln, char *pat, int lnPos, int patPos, int maxLn, int maxPat) {

    // We've exceeded the limit of either the line or the pattern.
    if (lnPos >= maxLn && patPos < maxPat) { // chars left in pattern. ???
        return pat[patPos] == '*' ? 1 : 0;
    } else if (patPos >= maxPat && lnPos < maxLn) { // finished the pattern
        return 1;
    } else if (lnPos >= maxLn && patPos >= maxPat) { // finished both
        return 1;
    } else if (pat[patPos] == '*') {
        if (pat[patPos - 1] == ln[lnPos] || pat[patPos - 1] == '.') {
            return matcher(ln, pat, lnPos + 1, patPos, maxLn, maxPat);
        } else {
            return matcher(ln, pat, lnPos + 1, patPos + 1, maxLn, maxPat);
        }
    } else if (pat[patPos] == '\\') {
        if (pat[patPos + 1] == ln[lnPos]) {
            return matcher(ln, pat, lnPos + 1, patPos + 1, maxLn, maxPat);
        } else {
            return matcher(ln, pat, lnPos + 1, patPos, maxLn, maxPat);
        }
    } else if (ln[lnPos] == pat[patPos] || pat[patPos] == '.') { // correct.
        return matcher(ln, pat, lnPos + 1, patPos + 1, maxLn, maxPat);
    } else {
        return matcher(ln, pat, lnPos + 1, patPos, maxLn, maxPat);
    }
}
