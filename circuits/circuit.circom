// SPDX-License-Identifier: MIT

pragma circom 2.0.0;

include "./mimcsponge.circom";
include "./comparators.circom";


template Main() {
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal input x3;
    signal input y3;
    signal input area;

    signal output pub1;
    signal output pub2;
    signal output pub3;

    /* check x2^2 + y2^2 < r^2 */


     /* check x1 * (y2-y3) + x2 * (y3-y1) + x3 * (y1-y2) <= area * 2 */
    
    signal diffY1;
    diffY1 <== y2 - y3;
    signal diffY2;
    diffY2 <== y3 - y1;
    signal diffY3;
    diffY3 <== y1 - y2;

  component ltDist = LessThan(32);
  signal firstDist;
  signal secondDist;
  signal thirdDist;
  firstDist <== x1 * diffY1;
  secondDist <== x2 * diffY2;
  thirdDist <== x3 * diffY3;
  ltDist.in[0] <== firstDist + secondDist + thirdDist;
  ltDist.in[1] <== area * 2;
  ltDist.out === 1;


  /* check MiMCSponge(x1,y1) = pub1, MiMCSponge(x2,y2) = pub2, MiMCSponge (x3, y3) = pub3 */

    component mimc1 = MiMCSponge(2, 220, 1);
    component mimc2 = MiMCSponge(2, 220, 1);
    component mimc3 = MiMCSponge(2, 220, 1);

    mimc1.ins[0] <== x1;
    mimc1.ins[1] <== y1;
    mimc1.k <== 0;
    mimc2.ins[0] <== x2;
    mimc2.ins[1] <== y2;
    mimc2.k <== 0;
    mimc3.ins[0] <== x3;
    mimc3.ins[1] <== y3;
    mimc3.k <== 0;

    pub1 <== mimc1.outs[0];
    pub2 <== mimc2.outs[0];
    pub3 <== mimc3.outs[0];

}

component main = Main();