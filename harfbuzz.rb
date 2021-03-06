class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.9.0.tar.bz2"
  sha256 "11eca62bf0ac549b8d6be55f4e130946399939cdfe7a562fdaee711190248b00"

  bottle do
    sha256 "0bb82176ab60f4021bfda809136bc398006b3d3ba05447eddb96f963946297df" => :mojave
    sha256 "1d4ea4bdf5f1711ab69cbd7851f8265a59e8e0be39f55de0c3b91a05138f4208" => :high_sierra
    sha256 "e941d2dc406e12806fc36f67168a2ff5769121c462ab4fc46b0b584b94790b9a" => :sierra
    sha256 "7bf90617c7f5cfbe885849984d67a1891b6eadb0a587a503d9709ff530b24224" => :el_capitan
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "ragel" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "glib"
  depends_on "gmerlino/cairo/cairo" => "with-x11"
  depends_on "graphite2"
  depends_on "icu4c"

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-introspection=yes
      --enable-static
      --with-cairo=yes
      --with-coretext=yes
      --with-freetype=yes
      --with-glib=yes
      --with-gobject=yes
      --with-graphite2=yes
      --with-icu=yes
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
