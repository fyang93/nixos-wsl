{pkgs, ...}:

{
  environment.systemPackages = let
    my-python-packages = ps: with ps; [
      jupyter
      ipython
      pandas
      # other python packages
    ];
  in [
    pkgs.pkg-config # required to install libvirt-python
    (pkgs.python3.withPackages my-python-packages)
  ];
}