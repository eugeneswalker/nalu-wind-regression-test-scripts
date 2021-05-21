# README
# 1. Source Spack
# 2. Load nalu-wind
# 3. Run this script

#!/bin/bash -e

if [[ ! -d nalu-wind ]] ; then
 git clone https://github.com/exawind/nalu-wind
 (cd nalu-wind && git submodule update --init --recursive)
fi

resultfile="$(pwd)/test-results.txt"

for t in $(cat test-list.txt) ; do
  n=$(echo $t | cut -d: -f1)
  np=$(echo $t | cut -d: -f2)
  (
    OK=1
    cd nalu-wind/reg_tests/test_files/${n} || OK=0
    if [[ $OK -eq 1 ]]; then
      mpirun --use-hwthread-cpus -np ${np} naluX -i ${n}.yaml >/dev/null 2>&1 && echo OK: ${n} || echo Bad Exit: ${n}
      #../../pass_fail.py ${n} ${n}.norm.gold | tee -a ${resultfile} || :
    fi
  )
done

sort -o ${resultfile} ${resultfile}
