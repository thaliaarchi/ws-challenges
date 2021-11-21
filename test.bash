#!/bin/bash

build=build
wspace=wspace

make -k
echo euler/1: ; diff euler/1.out <($wspace $build/euler/1.ws < euler/1.in)
echo euler/2: ; diff euler/2.out <($wspace $build/euler/2.ws < euler/2.in)
echo euler/4: ; diff euler/4.out <($wspace $build/euler/4.ws)
echo euler/6: ; diff euler/6.out <($wspace $build/euler/6.ws < euler/6.in)
echo euler/8: ; diff euler/8.out <($wspace $build/euler/8.ws < euler/8.in)
echo euler/11: ; diff euler/11.out <($wspace $build/euler/11.ws < euler/11.in)
echo euler/13: ; diff euler/13.out <($wspace $build/euler/13.ws < euler/13.in)
echo euler/14: ; diff euler/14.out <($build/euler/14 < euler/14.in)
echo euler/16: ; diff euler/16.out <($wspace $build/euler/16.ws < euler/16.in)
echo euler/17: ; diff euler/17.out <($wspace $build/euler/17.ws)
echo euler/34: ; diff euler/34.out <($wspace $build/euler/34.ws)
echo euler/36: ; diff euler/36.out <($wspace $build/euler/36.ws < euler/36.in)
echo euler/40: ; diff euler/40.out <($wspace $build/euler/40.ws)
echo euler/48: ; diff euler/48.out <($wspace $build/euler/48.ws)
echo advent/2020/1: ; diff advent/2020/1.out <($wspace $build/advent/2020/1.ws < advent/2020/1.in)
