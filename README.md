# check-EBUSY

Errno::EBUSY が発生するため Linuxbrew が動作しない環境について調査を行った。

```bash
$ brew install hello --build-from-source
==> Downloading http://ftpmirror.gnu.org/hello/hello-2.10.tar.gz
==> Downloading from http://mirror.jre655.com/GNU/hello/hello-2.10.tar.gz
######################################################################## 100.0%
==> ./configure --disable-silent-rules --prefix=/path/to/linuxbrew/Cellar/hello/2.10
==> make install
Error: Device or resource busy @ rb_file_s_rename - (/path/to/linuxbrew/Cellar/hello/2.10/INSTALL_RECEIPT.json20160522-29445-10ru2uv, /path/to/linuxbrew/Cellar/hello/2.10/INSTALL_RECEIPT.json)
```

この問題が発生する環境では以下の Ruby コードが失敗する。

```ruby
require 'tempfile'

tf = Tempfile.new('tempfile.src', './')
File.rename(tf.path, 'tempfile.dst')
```

```bash
$ ./tempfile.rb
./tempfile.rb:7:in `rename': Device or resource busy @ rb_file_s_rename - (./tempfile.src20160522-1876-1l1026o, tempfile.dst) (Errno::EBUSY)
	from ./tempfile.rb:7:in `<main>'
```

これは Ruby の問題ではなく、C言語で「開いたファイルを rename する」処理を行っても同様に失敗する。

```bash
$ gcc -o rename rename.c
$ ./rename
Failure.
```

Workaround は rename/unlink する前にファイルを close することである。
