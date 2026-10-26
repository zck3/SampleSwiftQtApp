#!/usr/bin/bash

runs=10
segfaults=0
timeouts=0
successes=0
other=0

for (( i = 1; i <= runs; i++ )); do
	timeout --signal=TERM \
		--kill-after=1s 5s \
		./.build/debug/SampleSwiftQtApp \
		>/tmp/swiftqt-test.log 2>&1
	rc=$?

	case "$rc" in
		0)   (( successes++ )) ;;
		124) (( timeouts++ )) ;;
		137) (( timeouts++ )) ;;
		139) (( segfaults++ )) ;;
		*)   (( other++ )) ;;
	esac
done

printf '| Total runs: %d\n| Successes: %d\n| Segfaults: %d\n| Timeouts: %d\n| Other issues: %d\n' \
	"$runs" "$successes" "$segfaults" "$timeouts" "$other"
