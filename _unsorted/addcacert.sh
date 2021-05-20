cat <<EOF > /tmp/ca.crt
-----BEGIN CERTIFICATE-----
-----END CERTIFICATE-----
EOF

sudo cp /tmp/ca.crt /usr/local/share/ca-certificates/kubernetes.crt
sudo update-ca-certificates
rm /tmp/ca.crt
