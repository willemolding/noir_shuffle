use dep::std::ec::tecurve::affine::Curve as AffineCurve;
use dep::std::ec::tecurve::affine::Point as Gaffine;

use dep::remask::exp_elgamal_remask;

// number of cards in a deck
global N: Field = 52;

fn main(
    apk: pub Gaffine,
    preshuffle: pub [(Gaffine,Gaffine); N],
    index: pub Field,
    shuffle: [Field; N],
    rand: Field,
) -> pub (Gaffine,Gaffine) {
    assert_valid_permutation(shuffle);
    exp_elgamal_remask(apk, preshuffle[shuffle[index]], rand)
}

fn assert_valid_permutation(m: [Field; N]) {
    // check that each index between 0 and N-1 appears exactly once in the array
    let mut seen = [false; N];
    for i in 0..N {
        assert(m[i] as u32 < N as u32);
        assert(!seen[m[i]]);
        seen[m[i]] = true;
    }
}
