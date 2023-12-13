use dep::std::ec::tecurve::affine::Curve as AffineCurve;
use dep::std::ec::tecurve::affine::Point as Gaffine;
use dep::std::ec::consts::te::baby_jubjub;

/// Exponential ElGamal re-Encryption on Baby Jubjub,
/// input is the resulting ciphertext of an ElGamal encryption, i.e a tuple of two points on the Baby Jubjub curve
/// The randomness parameter should be sampled uniformly between 0 and bjj_l-1 and NEVER reused. bjj_l is the order of the big prime subgroup of Baby Jubjub.
/// Same notations as in https://en.wikipedia.org/wiki/ElGamal_encryption 
/// remask operation defined in https://geometryresearch.xyz/notebook/mental-poker-in-the-age-of-snarks-part-2
/// The public_key point passed as an argument must correspond to a valid public key, i.e an element of the Baby Jubjub curve
pub fn exp_elgamal_remask(
    public_key: Gaffine,
    input: (Gaffine, Gaffine),
    randomness: Field
) -> (Gaffine, Gaffine) {
    assert(is_valid_subgroup(public_key)); // checks the public key is valid
    let bjj_affine = get_affine_curve();
    let base_pt = get_base_point();
    let C1: Gaffine = bjj_affine.add(input.0, bjj_affine.mul(randomness, base_pt));
    let C2: Gaffine = bjj_affine.add(input.1, bjj_affine.mul(randomness, public_key));
    (C1, C2)
}

fn get_affine_curve() -> AffineCurve {
    baby_jubjub().curve
}

fn get_base_point() -> Gaffine {
    baby_jubjub().base8
}

/// This function checks that a point is in the big prime subgroup of the Baby Jubjub curve. 
/// It is used to check that a public key is valid.
pub fn is_valid_subgroup(point: Gaffine) -> bool {
    let bjj_affine = get_affine_curve();
    let bjj_suborder = baby_jubjub().suborder;
    let is_on_curve = bjj_affine.contains(point); // checks the point is on bjj
    let is_in_big_prime_subgroup = bjj_affine.mul(bjj_suborder, point).is_zero(); // checks the point is in the big prime subgroup of bjj
    is_on_curve & is_in_big_prime_subgroup
}
