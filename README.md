# Phishshield-VM
Phishshield project bundled into a Virtual Machine that can be directly launched inside any machine directly as long as you have Vagrant install.
How to run:
First make sure you have Vagrant installed on your system. You can download it from [here](https://developer.hashicorp.com/vagrant/install)
Then get Google Gemini API key and the OCR API key from [here](https://ocr.space/ocrapi).
Both of those API keys are free. after getting them, add them to the **env-vars** file like this.
```
GEMINI_API_KEY=<your key>
OCR_API_KEY=<your key>
```
**Don't change any other values in the env-vars file.**

Then go to that directory and run the following script.
```vagrant up```

That's all. You're all set. 
Now you can access the website at **http://192.168.33.33:5173/**
