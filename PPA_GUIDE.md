# PPA Upload Instructions

## Building the Package

### Prerequisites
```bash
sudo apt-get install dpkg-dev debhelper devscripts
```

### Build Methods

#### 1. Local Testing (Binary Package)
```bash
chmod +x build-deb.sh
./build-deb.sh --binary
```

#### 2. PPA Distribution (Source Package)
```bash
./build-deb.sh --source
```

#### 3. Build All
```bash
./build-deb.sh --all
```

## Signing and Uploading

### 1. Create a GPG Key (if not exists)
```bash
gpg --full-generate-key
# Select: RSA and RSA, 4096 bits, no expiration, real name, email
```

### 2. Upload Key to Ubuntu Keyserver
```bash
gpg --send-keys <KEY_ID>
```

### 3. Add Your PPA to Launchpad
- Visit: https://launchpad.net/~username/+create-ppa
- Create a PPA (e.g., `erp-server-setup`)

### 4. Configure dput
Create/update `~/.dput.cf`:
```ini
[ppa]
fqdn = ppa.launchpad.net
method = sftp
incoming = ~%(ppa)s/ubuntu/
login = username
allow_unsigned_uploads = 0
```

### 5. Sign the Package
```bash
debsign -k<YOUR_KEY_ID> erp-server-setup_1.0.0-1_source.changes
```

### 6. Upload to PPA
```bash
dput ppa:eltongomez/erp-server-setup erp-server-setup_1.0.0-1_source.changes
```

## Installation from PPA

After upload and processing:
```bash
sudo add-apt-repository ppa:eltongomez/erp-server-setup
sudo apt-get update
sudo apt-get install erp-server-setup
```

## Verification

### Check Package Contents
```bash
dpkg -c erp-server-setup_1.0.0-1_amd64.deb
```

### Verify Signature
```bash
dpkg-sig --verify erp-server-setup_1.0.0-1_amd64.deb
```

### Install and Test
```bash
sudo dpkg -i erp-server-setup_1.0.0-1_amd64.deb
sudo erp-server-setup --help
```

## Troubleshooting

### Build Fails with Missing Dependencies
```bash
sudo apt-get install debhelper dh-exec dh-bash
```

### Upload Rejected
- Check file permissions
- Verify GPG key is uploaded
- Ensure email is verified on Launchpad
- Check changelog format

### PPA Build Fails on Launchpad
- Visit: https://launchpad.net/~username/+archive/ubuntu/ppa/+builds
- Check build logs for errors
- Common issues:
  - Missing Build-Depends in `debian/control`
  - Script paths incorrect in `debian/rules`
  - File permissions issues

## Maintenance

### Update for New Release
1. Update version in `debian/changelog`
2. Update `VERSION` in main script
3. Rebuild and upload

### Supported Distributions
Current targets (in debian/control):
- Focal (Ubuntu 20.04 LTS)
- Jammy (Ubuntu 22.04 LTS)
- Noble (Ubuntu 24.04 LTS)
- Bionic (Ubuntu 18.04 LTS)
- Xenial (Ubuntu 16.04 LTS)

## Resources

- [Debian Packaging Guide](https://www.debian.org/doc/manuals/debian-faq/pkg-basics.html)
- [Ubuntu PPA Guide](https://help.launchpad.net/Packaging/PPA)
- [Debhelper Documentation](https://manpages.debian.org/debhelper)
- [Launchpad Help](https://help.launchpad.net/)
