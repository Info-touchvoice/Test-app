from __future__ import print_function
import os, sys, ssl, zipfile

THIS_SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))

def main():
    # 忽略 SSL 证书校验
    ssl._create_default_https_context = ssl._create_unverified_context

    deps_dir = os.path.join(THIS_SCRIPT_PATH, 'deps')
    if os.path.exists(os.path.join(deps_dir, 'release')):
        print('[*] Native SDK already exists, exit!')
        return 0

    # 读取 VERSION 文件，获取下载 URL
    with open(os.path.join(deps_dir, 'VERSION'), 'r') as f:
        url = f.read().strip()

    artifact = os.path.join(deps_dir, url.split('/')[-1].split('?')[0])
    print('[*] Downloading native SDK from "{}"'.format(url))

    if sys.version_info.major == 2:
        import urllib
        urllib.urlretrieve(url, artifact)
    else:
        import urllib.request

        # 使用防盗链 Referer 下载
        req = urllib.request.Request(
            url,
            headers={'Referer': 'https://doc-zh.zego.im'}
        )
        with urllib.request.urlopen(req) as response, open(artifact, 'wb') as out_file:
            out_file.write(response.read())

    # 解压缩
    with zipfile.ZipFile(artifact, 'r') as f:
        f.extractall(deps_dir)
    print('[*] Download SDK success!')
    os.remove(artifact)

if __name__ == '__main__':
    sys.exit(main())
