{ lib
, buildGoModule
, fetchFromGitHub
, ...
}:
with lib;
buildGoModule rec {
  pname = "ogen";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-khUY8PQ12p0slleidysZiGWyZNX3XCxwD55lfRDCwew=";
  };

  vendorHash = "sha256-kHfp77jKPBt+EKAc52nXdqR4TJ3OVj7mqo4vfv2XelQ=";

  meta = {
    description = "OpenAPI v3 code generator for go";
    homepage = "https://github.com/ogen-go/ogen";
    license = licenses.asl20;
    maintainers = with maintainers; [ qbit ];
  };
}
