# -*- encoding: utf-8 -*-
# stub: scrypt 3.0.3 ruby lib
# stub: ext/scrypt/Rakefile

Gem::Specification.new do |s|
  s.name = "scrypt"
  s.version = "3.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Patrick Hogan", "Stephen von Takach", "Rene van Paassen"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDvDCCAqSgAwIBAgIBATANBgkqhkiG9w0BAQUFADBaMQ4wDAYDVQQDDAVzdGV2\nZTEfMB0GCgmSJomT8ixkARkWD2FkdmFuY2VkY29udHJvbDETMBEGCgmSJomT8ixk\nARkWA2NvbTESMBAGCgmSJomT8ixkARkWAmF1MB4XDTE2MDYyNjIyMjMyMloXDTE3\nMDYyNjIyMjMyMlowWjEOMAwGA1UEAwwFc3RldmUxHzAdBgoJkiaJk/IsZAEZFg9h\nZHZhbmNlZGNvbnRyb2wxEzARBgoJkiaJk/IsZAEZFgNjb20xEjAQBgoJkiaJk/Is\nZAEZFgJhdTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKvI6Zfmxakj\nADC7rWDhCtHDSCdn2jrzeMDO2xqq9P315j0x7YVglKF49Xz7OCnWGxn0Zzec22Ha\nxq2St09wLPtE6+/qTiq48ffxLKPR/Aahdk31HGx5AXDjRQ5p48m5CK3BDratshbi\nssg2bVMOxMSnNowb5Mqc448X2shYHwfuo9C4fsvkn0eC+XtpwOKBsLJnmYxI8opB\nA6cL5onHD1JH5Ywt7mWn3XCGEZY98Hq3V7wpCACWSHP9FfCmf0Vyn30UTlBivoUh\nqmtLB+TDW4Qvma/1cc7p1e3HF9xQHSza9FTyfhzw/vxnSF+jT4upUtXdhCTMqqDv\nm597hs3/6z8CAwEAAaOBjDCBiTAJBgNVHRMEAjAAMAsGA1UdDwQEAwIEsDAdBgNV\nHQ4EFgQUqqCOTfINjbAqX/8nFvbzHcYG8xIwJwYDVR0RBCAwHoEcc3RldmVAYWR2\nYW5jZWRjb250cm9sLmNvbS5hdTAnBgNVHRIEIDAegRxzdGV2ZUBhZHZhbmNlZGNv\nbnRyb2wuY29tLmF1MA0GCSqGSIb3DQEBBQUAA4IBAQB/DUhYFbdLHAuZMgjwNUxF\ntnf3a2o40p9mEtVm48yxfP9/9w6xh+gRN/rbBCkKbe2zSue9Nnr3zfKNONfqePlz\n9BZOMx7LO/wFOkuWONIU+U7v5Obxi7a0bjZ6OQnY5M6FpuWG5RT6hVIlkbrh40Xd\nSgbJ2CyHXTL3tC7ykvvI5nXQLE6OG8lyHk5Cop2Lbm4qeBVCVEDgDsXi/PFP+hjk\nwpN2wi2CVPoj+c4bOYxgvF17WNGDWYdVEXXCRzoqGbA2kLbTH1o9BxI6NBzmfwyH\nLY7uYxN8Hy8S4Oto/gB1eREHqYwwXt3TmlJ6kAVGbO5y9xblPncdnfwNLCUnPfxN\n-----END CERTIFICATE-----\n"]
  s.date = "2016-08-15"
  s.description = "    The scrypt key derivation function is designed to be far\n    more secure against hardware brute-force attacks than\n    alternative functions such as PBKDF2 or bcrypt.\n"
  s.email = ["pbhogan@gmail.com", "steve@advancedcontrol.com.au", "rene.vanpaassen@gmail.com"]
  s.extensions = ["ext/scrypt/Rakefile"]
  s.files = ["ext/scrypt/Rakefile"]
  s.homepage = "https://github.com/pbhogan/scrypt"
  s.licenses = ["MIT"]
  s.rubyforge_project = "scrypt"
  s.rubygems_version = "2.5.1"
  s.summary = "scrypt password hashing algorithm."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi-compiler>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<awesome_print>, [">= 0"])
    else
      s.add_dependency(%q<ffi-compiler>, [">= 1.0.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
    end
  else
    s.add_dependency(%q<ffi-compiler>, [">= 1.0.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
  end
end
