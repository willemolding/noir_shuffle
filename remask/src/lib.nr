use dep::std::ec::tecurve::affine::Curve as AffineCurve;
use dep::std::ec::tecurve::affine::Point as Gaffine;

global bjj_a = 168700;
global bjj_d = 168696;
global bjj_generator_x = 995203441582195749578291179787384436505546430278305826713579947235728471134;
global bjj_generator_y = 5472060717959818805561601436314318772137091100104008585924551046643952123905;
global bjj_basept_x    = 5299619240641551281634865583518297030282874472190772894086521144482721001553;
global bjj_basept_y    = 16950150798460657717958625567821834550301663161624707787222815936182638968203;
global bjj_l = 2736030358979909402780800718157159386076813972158567259200215660948447373041; // order of the big prime subgroup of the curve = order of basept

/// Exponential ElGamal re-Encryption on Baby Jubjub,
/// input is the resulting ciphertext of an ElGamal encryption, i.e a tuple of two points on the Baby Jubjub curve
/// The randomness parameter should be sampled uniformly between 0 and bjj_l-1 and NEVER reused. bjj_l is the order of the big prime subgroup of Baby Jubjub.
/// Same notations as in https://en.wikipedia.org/wiki/ElGamal_encryption 
/// remask operation defined in https://geometryresearch.xyz/notebook/mental-poker-in-the-age-of-snarks-part-2
/// The public_key point passed as an argument must correspond to a valid public key, i.e an element of the Baby Jubjub curve
pub fn exp_elgamal_remask(
    public_key: Gaffine,
    input: (Gaffine,Gaffine),
    randomness: Field
) -> (Gaffine,Gaffine) {
    assert(is_valid_subgroup(public_key)); // checks the public key is valid
    let bjj_affine = get_affine_curve();
    let base_pt = get_base_point();
    let C1: Gaffine = bjj_affine.add(input.0, bjj_affine.mul(randomness, base_pt));
    let C2: Gaffine = bjj_affine.add(input.1, bjj_affine.mul(randomness, public_key));
    (C1, C2)
}

fn get_affine_curve() -> AffineCurve {
    AffineCurve::new(bjj_a, bjj_d, Gaffine::new(bjj_generator_x, bjj_generator_y))
}

fn get_base_point() -> Gaffine {
    Gaffine::new(bjj_basept_x, bjj_basept_y)
}

/// This function checks that a point is in the big prime subgroup of the Baby Jubjub curve. 
/// It is used to check that a public key is valid.
fn is_valid_subgroup(point: Gaffine) -> bool {
    let bjj_affine = get_affine_curve();
    let is_on_curve = bjj_affine.contains(point); // checks the point is on bjj
    let is_in_big_prime_subgroup = bjj_affine.mul(bjj_l, point).is_zero(); // checks the point is in the big prime subgroup of bjj
    is_on_curve & is_in_big_prime_subgroup
}
