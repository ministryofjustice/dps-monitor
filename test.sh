sleep 5
if curl http://app:3030/health ; then
  echo "Tests passed!"
  exit 0
else
  echo "Tests failed!"
  exit 1
fi
