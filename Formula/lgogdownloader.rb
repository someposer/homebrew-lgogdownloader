class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.7.tar.gz"
  sha256 "984859eb2e0802cfe6fe76b1fe4b90e7354e95d52c001b6b434e0a9f5ed23bf0"
  revision 4
  head "https://github.com/Sude-/lgogdownloader.git"

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "htmlcxx"
  depends_on "jsoncpp"
  depends_on "liboauth"
  depends_on "rhash"
  depends_on "tinyxml2"
  depends_on "qt@5" => :optional

  def install
    args = std_cmake_args
    args << "-DJSONCPP_INCLUDE_DIR=#{Formula["jsoncpp"].opt_include}"
    args << "-DUSE_QT_GUI=ON" if build.with? "qt@5"

    system "cmake", ".", *args

    system "make", "install"
  end

  test do
    require "pty"

    ENV["XDG_CONFIG_HOME"] = testpath
    reader, writer = PTY.spawn(bin/"lgogdownloader", "--list", "--retries", "1")
    writer.write <<~EOS
      test@example.com
      secret
    EOS
    writer.close
    assert_equal "HTTP: Login failed", reader.read.lines.last.chomp
    reader.close
  end
end
