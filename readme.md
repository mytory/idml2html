# idml2html

## Installation

Run `sudo ./install.sh`. The script link files to `/usr/local/bin` folder.

Use like below.

    idml2html idmlfile.idml result.html

You need perl for this script.

### Korean

`sudo ./install.sh`을 실행한다. 이 스크립트는 `/usr/local/bin` 폴더에 링크를 건다.

아래처럼 사용하면 된다.

    idml2html idmlfile.idml result.html

이 스크립트를 실행하려면 펄이 필요하다.


## Manual usage

This is script that convert InDesign `idml` to `html`.

In fact, `idml` is `zip` file. You can `unzip` `idml` file. So you can find `xml` files in it. This is a perl script convert the `xml` file to `html`.

1. Unzip `idml` file(`unzip idml-file.idml`).
2. `Stories` folder contains the text that is `xml`. Run the following script.
3. `for f in Stories/* ; do idml2html.pl "$f" ; printf "\n\n------\n\n" ; done > result.html`


### Korean

인디자인에서 `idml`로 저장한 파일을 `html`로 변환하는 스크립트다. 

사실 `idml`은 `zip` 파일이다. `unzip`으로 압축을 풀면 풀린다. 그럼 그 안에 `xml` 파일들이 들어 있는데, 이 `xml` 파일을 `html`로 변환하는 펄 스크립트다.

1. `idml` 파일 압축 푼다 (`unzip idml-file.idml`)
2. `Stories` 폴더 안에 `xml`로 본문이 들어 있다. 아래 스크립트를 실행한다.
3. `for f in Stories/* ; do idml2html.pl "$f" ; printf "\n\n------\n\n" ; done > result.html`
