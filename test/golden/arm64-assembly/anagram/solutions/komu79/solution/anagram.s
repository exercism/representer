.section .rodata
        .balign 16
.Lletters:
        .ascii  "abcdefghijklmnopqrstuvwxyz"
        .zero   6

.text
.globl find_anagrams

is_anagram      .req x0
candidates      .req x1
num_candidates  .req x2
subject         .req x3
candidate_idx   .req x4
ch1             .req w5
ch2             .req w6
str1            .req x7
str2            .req x8
candidate       .req x9
candidate_ok    .req w10
tmp_x           .req x11

hist_sub1       .req v1
hist_sub2       .req v2
hist_cand1      .req v3
hist_cand2      .req v4
letters1_v      .req v5
letters1_q      .req q5
letters2_v      .req v6
letters2_q      .req q6
char_v          .req v7
match1          .req v16
match2          .req v17
tmp_v           .req v18
tmp_d           .req d18

// Increments/decrements counts of given histograms from letters of given string. 
// Assumes letters are ASCII and that individual letters have at most 255 repetitions,
// which allows storing the histograms in two vector registers. 
.macro counts mode src h1 h2
        mov     str1, \src
        b       .Lcounts_check\@
.Lcounts_loop\@:
        orr     ch1, ch1, #32                           // lowercase
        dup     char_v.16b, ch1
        cmeq    match1.16b, char_v.16b, letters1_v.16b  // all-ones (-1) in the lane of this letter
        cmeq    match2.16b, char_v.16b, letters2_v.16b
.ifc \mode, inc
        sub     \h1, \h1, match1.16b                    // sub -1 (add 1) for matching letters
        sub     \h2, \h2, match2.16b
.else
        add     \h1, \h1, match1.16b                    // add -1 (sub 1) for matching letters
        add     \h2, \h2, match2.16b
.endif
.Lcounts_check\@:
        ldrb    ch1, [str1], #1
        cbnz    ch1, .Lcounts_loop\@
.endm

find_anagrams:
        mov     candidate_idx, #0
        
        ldr     letters1_q, .Lletters                           // load letters into vector registers
        ldr     letters2_q, .Lletters + 16
        movi    hist_sub1.16b, #0                               // reset histogram to zeros
        movi    hist_sub2.16b, #0
        counts  inc, subject, hist_sub1.16b, hist_sub2.16b      // prepare histogram for subject

        b       .Lcheck_next_candidate
.Lnext_candidate:
        ldr     candidate, [candidates, candidate_idx, lsl #3]

        mov     hist_cand1.16b, hist_sub1.16b
        mov     hist_cand2.16b, hist_sub2.16b
        counts  dec, candidate, hist_cand1.16b, hist_cand2.16b
        orr     tmp_v.16b, hist_cand1.16b, hist_cand2.16b       // check that counts are zero
        umaxp   tmp_v.4s, tmp_v.4s, tmp_v.4s
        fmov    tmp_x, tmp_d
        cbnz    tmp_x, .Lcandidate_fail                         // had non-zero count, reject the candidate

        // We had all the same letters. But perhaps this is the same string?
        // We already know they have the same length, so we can simplify the loop a bit
        mov     str1, subject
        mov     str2, candidate
1:      ldrb    ch1, [str1], #1
        cbz     ch1, .Lcandidate_fail   // strings were the same, reject the candidate
        ldrb    ch2, [str2], #1
        eor     ch1, ch1, ch2           // compare letters
        tst     ch1, #~32               // ignore differences in bit 5 (case)
        b.eq    1b

        mov     candidate_ok, #1
        b       2f
.Lcandidate_fail:
        mov     candidate_ok, #0
2:      str     candidate_ok, [is_anagram, candidate_idx, lsl #2]
        add     candidate_idx, candidate_idx, #1        
.Lcheck_next_candidate:
        cmp     candidate_idx, num_candidates
        b.lo    .Lnext_candidate
        ret        
