#ifndef UTILS_C
#define UTILS_C

#include "stdlib/stdtypes.h"

struct testresults {
    int total;
    int passed;
};

void assert_equal(int expected, int actual, const char *message, struct testresults *results) {
    if (expected != actual) {
        printf("%s: expected %d but was actually %d\n", message, expected, actual);
        results->passed--;
    }
    results->total++;
    results->passed++;
}

void assert_unequal(int expected, int actual, const char *message, struct testresults *results) {
    if (expected == actual) {
        printf("%s: expected not %d but was actually %d\n", message, expected, actual);
        results->passed--;
    }
    results->total++;
    results->passed++;
}

void assert_true(bool actual, const char *message, struct testresults *results) {
    if (!actual) {
        printf("%s: expected true but was actually false\n", message);
        results->passed--;
    }
    results->total++;
    results->passed++;
}

void assert_false(bool actual, const char *message, struct testresults *results) {
    if (!actual) {
        printf("%s: expected false but was actually true\n", message);
        results->passed--;
    }
    results->total++;
    results->passed++;
}

#endif // UTILS_C