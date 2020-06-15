@echo off
route -p add 10.10.0.0 mask 255.255.0.0 10.20.39.254
route -p add 10.20.0.0 mask 255.255.0.0 10.20.39.254
::route -p add 10.10.0.0 mask 255.255.0.0 10.20.39.254
::route -p add 10.30.0.0 mask 255.255.0.0 10.20.39.254
echo route print
pause