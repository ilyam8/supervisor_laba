#!/bin/bash
a=$[ ( $RANDOM % 10 )  + 1 ]
echo "Sleeping $a seconds..."
sleep $a
echo "done. Exiting."
