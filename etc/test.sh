#!/bin/bash
task_number=$1

sql=task${task_number}.sql
csv=task${task_number}.csv

expected_csv=./etc/${csv}
actual_csv=/tmp/${csv}

if [ ! -f $sql ]
then
  echo "Make sure that $sql exists."
  exit 1
fi

psql -U postgres -f $sql -t -A -F, -o $actual_csv northwind

echo "=== EXPECTED RESULTS START ==="
cat $expected_csv
echo "=== EXPECTED RESULTS END ====="
echo ""
echo "=== YOUR RESULTS START ==="
cat $actual_csv
echo "=== YOUR RESULTS END ====="
echo ""
echo === DIFFERENCE START ===
sdiff $expected_csv $actual_csv
exit_code=$?
echo === DIFFERENCE END =====

if [ $exit_code -ne 0 ]
then
  echo "The output of your SQL script ($sql) doesn't match the expected results in $csv."
  exit 1
fi
