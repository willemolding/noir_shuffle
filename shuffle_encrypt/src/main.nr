use dep::std::ec::tecurve::affine::Curve as AffineCurve;
use dep::std::ec::tecurve::affine::Point as Gaffine;

use dep::remask::exp_elgamal_remask;

// number of cards in a deck
global N: Field = 6;

fn main(
    apk: pub Gaffine,
    preshuffle: pub [(Gaffine,Gaffine); N],
    postshuffle: pub [(Gaffine,Gaffine); N],
    shuffle: [Field; N],
    rand: [Field; N],
) {
    assert_valid_permutation(shuffle);
    for i in 0..N {
        let result = exp_elgamal_remask(apk, preshuffle[shuffle[i]], rand[i]);
        assert_points_equal(result.0, postshuffle[i].0);
        assert_points_equal(result.1, postshuffle[i].1);
    }
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

fn assert_points_equal(p1: Gaffine, p2: Gaffine) {
    assert(p1.x == p2.x);
    assert(p1.y == p2.y);
}
