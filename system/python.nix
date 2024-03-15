{pkgs, ...}:

{
  environment.systemPackages = let
    my-python-packages = ps: with ps; [
      jupyter
      ipython
      pandas
      soundfile
      pydub
      tqdm
      rich
      pyppeteer
      aiofiles
      # other python packages
    ];
  in [
    pkgs.pkg-config # required to install libvirt-python
    (pkgs.python3.withPackages my-python-packages)
  ];
}