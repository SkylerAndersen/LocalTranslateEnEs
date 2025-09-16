#include <sentencepiece_processor.h>
#include <ctranslate2/translator.h>
#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <sstream>

class TranslationAPI {
private:
	ctranslate2::Translator* enEs = nullptr;
	ctranslate2::Translator* esEn = nullptr;
	sentencepiece::SentencePieceProcessor* enTokenizer = nullptr;
	sentencepiece::SentencePieceProcessor* esTokenizer = nullptr;

	std::string translateEsEn (const std::string& input) {
		// tokenize input
		std::vector<std::string> batch;
		esTokenizer->Encode(input,&batch);
		batch.push_back("</s>");

		// translate tokenized spanish to tokenized english
		const std::vector<std::string> translation = (esEn->translate_batch({batch}))[0].output();

		// detokenize output
		std::string output;
		enTokenizer->Decode(translation,&output);

		return output;
	}

	std::string translateEnEs (const std::string& input) {
		// tokenize input
		std::vector<std::string> batch;
		enTokenizer->Encode(input,&batch);
		batch.push_back("</s>");

		// translate tokenized english to tokenized spanish
		const std::vector<std::string> translation = (enEs->translate_batch({batch}))[0].output();

		// detokenize output
		std::string output;
		esTokenizer->Decode(translation,&output);

		return output;
	}

public:
	TranslationAPI (const std::string& modelsDirectory) {
		// gather paths
		const std::string enEsPath(modelsDirectory + "/ct2-en-es");
		const std::string esEnPath(modelsDirectory + "/ct2-es-en");
		const std::string enVocab(modelsDirectory + "/en.spm");
		const std::string esVocab(modelsDirectory + "/es.spm");
				
		// load ctranslate2 models (en-es and es-en)
		const ctranslate2::models::ModelLoader enEsLoader(enEsPath);
		const ctranslate2::models::ModelLoader esEnLoader(esEnPath);
		enEs = new ctranslate2::Translator(enEsLoader);
		esEn = new ctranslate2::Translator(esEnLoader);

		// load tokenizers
		enTokenizer = new sentencepiece::SentencePieceProcessor();
		esTokenizer = new sentencepiece::SentencePieceProcessor();
		bool status = enTokenizer->Load(enVocab).ok();
		status = esTokenizer->Load(esVocab).ok() && status;
		if (!status)
			throw new std::runtime_error("SentencePieceModels failed to load vocab.");
	}

	std::string translate (const std::string& input, bool enToEs) {
		if (enToEs)
			return translateEnEs(input);
		return translateEsEn(input);
	}
};

int main(int argc, char* argv[]) {
	if (argc == 1)
		return 0;

	// create api for translation
	const std::string modelsPath(std::string(getenv("HOME")) + "/LocalTranslateEnEs/models");
	TranslationAPI api(modelsPath);
	
	// read args and create input
	bool hasFlag = (argv[1][0] == '-');
	bool isEnToEs = !(hasFlag && argv[1][2] == 's');
	std::stringstream inputStream;
	inputStream.str();
	for (int i = hasFlag ? 2 : 1; i < argc-1; i++)
		inputStream << argv[i] << ' ';
	inputStream << argv[argc-1];
	std::string input(inputStream.str());

	// translate and output
	std::cout << "Input: " << input << std::endl;
	std::string output = api.translate(input,isEnToEs);
	std::cout << "Output: " << output << std::endl;

	return 0;
}
