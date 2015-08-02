#include "mex.h"
#include "string.h"

#define MAX_LEN 200

char* strstrb(char * s, const char * str) {
    char *p = strstr(s, str);
    char *p0 = p;
    while (p != NULL) {
        p0 = p;
        p = strstr(p + 1, str);
    }
    
    return p0;
}

/*
 * function [f, s] = paperRename(s0)
 *
 * History
 *   create  -  Feng Zhou, 03-20-2009
 *   modify  -  Feng Zhou, 08-04-2009
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    // s0
    char s0[MAX_LEN];
    mxGetString(prhs[0], s0, MAX_LEN);

    // f
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    double *f = mxGetPr(plhs[0]);
    *f = 0;

    // allocate space for name, where, when
    char name[MAX_LEN] = {0};
    char where[MAX_LEN] = {0};
    char when[MAX_LEN] = {0};

    // pdf
    char* p = strstr(s0, ".pdf");
    if (p == NULL) {
        plhs[1] = mxCreateString("");
        return;
    }
    *p = 0;

    // ()
    char *p1 = strstrb(s0, "(");
    char *p2 = strstrb(s0, ")");
    if (p1 == NULL || p2 == NULL) {
        strncpy(name, s0, p - s0);
        strcpy(where, "xxxx");
        strcpy(when, "xxxx");

    } else {
        strncpy(name, s0, p1 - s0 - 1);

        // space
        char *p3 = strstr(p1, " ");
        if (p3 == NULL) {
           strncpy(when, p1 + 1, p2 - p1 - 1);
           strcpy(where, "xxxx");
        } else {
            strncpy(where, p1 + 1, p3 - p1 - 1);
            strncpy(when, p3 + 1, p2 - p3 - 1);
        }
    }

    *f = 1;

    // new string
    char s[MAX_LEN] = {0};
    strcpy(s, when);
    strcat(s, " - ");
    strcat(s, where);
    strcat(s, " - ");
    strcat(s, name);
    strcat(s, ".pdf");
    plhs[1] = mxCreateString(s);
}
