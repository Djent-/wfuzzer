wfuzzer.sh
====

It does some stuff with wfuzz

```bash
wfuzzer.sh http://example.com
```

```bash
wfpayload -z wfuzzp --zD .wfuzz/output/[session] --efield r.params.get 2>/dev/null
```

alias.sh
----

```bash
source alias.sh
wfz https://example.com/FUZZ{notthere}
```

scripts/elasticsearch.py
----

```bash
mkdir -p ~/.wfuzz/scripts
cp scripts/* ~/.wfuzz/scripts

wfuzz -z list,_stats --script=elasticsearch https://example.com:9200/FUZZ
```

Works best with my fixed fork of wfuzz
```bash
echo y | python3 -m pip uninstall wfuzz || sudo apt remove wfuzz -y
mkdir ~/build; cd ~/build
git clone https://github.com/Djent-/wfuzz
cd wfuzz
python3 -m pip install -r requirements.txt
python3 -m pip install .
sudo ln -s /usr/bin/python3.8 /usr/bin/python
```
