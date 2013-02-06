;;;; Autograding Summer 2000
;;;; Erik Klavon / erik@eriq.org

; this file runs another stk process, so that if the submitted code has bugs,
; we can kill that process, rather than hang if we ran our load and tests
; directly. We would hang otherwise because of the interactive nature of STk,
; which would wait around for another command if the student's code causes an
; error.


; the number we'll count up to before killing the process.
; adjust to suit the length of tests and system load.
(define wait 100000)

; this procedure checks our job to see f its alive, and kills it if its too
; old. We exit nonzero if we have the kill the process 
(define (check num job)
  (if (and (process-alive? job) (< num wait))
      (check (+ num 1) job)
      (begin
	(process-kill job)
        (if (> num (- wait 1))
	    (exit 1)))))


; run our test program asynchronously, pipe any output to /dev/null so it
; doesn't muck up our logs
(define job (run-process "stk" "-no-tk" "-file" "~cs61a/grading/testing/mk/beasic/test-load.scm" :error "/dev/null" :output "/dev/null" :wait #f))

; check it, kill if its too stale
(check 0 job)

; exit just in case with 0
(exit)

      
