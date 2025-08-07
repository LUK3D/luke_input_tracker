fn main() {
    // These are required for macOS native input APIs
    println!("cargo:rustc-link-lib=framework=Carbon");
    println!("cargo:rustc-link-lib=framework=ApplicationServices");
}
