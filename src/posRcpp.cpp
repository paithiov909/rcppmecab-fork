// [[Rcpp::depends(cpp11, BH)]]
#define R_NO_REMAP
#include <Rcpp.h>
#include <boost/algorithm/string.hpp>
#include "../inst/include/mecab.h"

using namespace Rcpp;

//' Call POS Tagger via `lapply` and return a list of named character vectors.
//'
//' @param text Character vector.
//' @param sys_dic String scalar.
//' @param user_dic String scalar.
//' @return list of named character vectors.
//'
//' @name posApplyRcpp
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
List posApplyRcpp(StringVector text, std::string sys_dic, std::string user_dic) {

  std::string args = "";
  if (sys_dic != "") {
    args.append(" -d ");
    args.append(sys_dic);
  }
  if (user_dic != "") {
    args.append(" -u ");
    args.append(user_dic);
  }

  // lattice model
  mecab_model_t* model;
  mecab_t* tagger;
  mecab_lattice_t* lattice;
  const mecab_node_t* node;

  // create model
  model = mecab_model_new2(args.c_str());
  if (!model) {
    Rcerr << "model is NULL" << std::endl;
    return R_NilValue;
  }

  tagger = mecab_model_new_tagger(model);
  lattice = mecab_model_new_lattice(model);

  String parsed_morph;
  String parsed_tag;
  List result;

  std::function< StringVector(String) > func = [&](String elem) {

    StringVector parsed_string;
    StringVector parsed_tagset;

    const std::string input = elem;
    mecab_lattice_set_sentence(lattice, input.c_str());
    mecab_parse_lattice(tagger, lattice);
    node = mecab_lattice_get_bos_node(lattice);

    for (; node; node = node->next) {
      if (node->stat == MECAB_BOS_NODE)
        ;
      else if (node->stat == MECAB_EOS_NODE)
        ;
      else {
        parsed_morph = std::string(node->surface).substr(0, node->length);
        parsed_morph.set_encoding(CE_UTF8);

        std::vector<std::string> features;
        boost::split(features, node->feature, boost::is_any_of(","));

        String parsed_tag = features[0];
        parsed_tag.set_encoding(CE_UTF8);

        parsed_string.push_back(parsed_morph);
        parsed_tagset.push_back(parsed_tag);
      }
    }

    parsed_string.names() = parsed_tagset;
    return parsed_string;
  };

  result = lapply(text, func);

  StringVector result_name(text.size());

  for (size_t h = 0; h < text.size(); ++h) {
    String character_name = text[h];
    character_name.set_encoding(CE_UTF8);
    result_name[h] = character_name;
  }

  result.names() = result_name;

  mecab_destroy(tagger);
  mecab_lattice_destroy(lattice);
  mecab_model_destroy(model);

  return result;
}

//' Call POS Tagger via `lapply` and return a named list.
//'
//' @param text Character vector.
//' @param sys_dic String scalar.
//' @param user_dic String scalar.
//' @return named list.
//'
//' @name posApplyJoinRcpp
//' @keywords internal
//' @export
// 
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
List posApplyJoinRcpp(StringVector text, std::string sys_dic, std::string user_dic) {

  std::string args = "";
  if (sys_dic != "") {
    args.append(" -d ");
    args.append(sys_dic);
  }
  if (user_dic != "") {
    args.append(" -u ");
    args.append(user_dic);
  }

  // lattice model
  mecab_model_t* model;
  mecab_t* tagger;
  mecab_lattice_t* lattice;
  const mecab_node_t* node;

  // create model
  model = mecab_model_new2(args.c_str());
  if (!model) {
    Rcerr << "model is NULL" << std::endl;
    return R_NilValue;
  }

  tagger = mecab_model_new_tagger(model);
  lattice = mecab_model_new_lattice(model);

  String parsed_morph;
  String parsed_tag;
  List result;

  std::function< StringVector(String) > func = [&](String elem) {

    StringVector parsed_string;

    const std::string input = elem;
    mecab_lattice_set_sentence(lattice, input.c_str());
    mecab_parse_lattice(tagger, lattice);
    node = mecab_lattice_get_bos_node(lattice);

    for (; node; node = node->next) {
      if (node->stat == MECAB_BOS_NODE)
        ;
      else if (node->stat == MECAB_EOS_NODE)
        ;
      else {
        parsed_morph = std::string(node->surface).substr(0, node->length);
        parsed_morph.push_back("/");

        std::vector<std::string> features;
        boost::split(features, node->feature, boost::is_any_of(","));

        parsed_morph.push_back(features[0]);
        parsed_morph.set_encoding(CE_UTF8);

        parsed_string.push_back(parsed_morph);
      }
    }

    return parsed_string;
  };

  result = lapply(text, func);

  StringVector result_name(text.size());

  for (size_t h = 0; h < text.size(); ++h) {
    String character_name = text[h];
    character_name.set_encoding(CE_UTF8);
    result_name[h] = character_name;
  }

  result.names() = result_name;

  mecab_destroy(tagger);
  mecab_lattice_destroy(lattice);
  mecab_model_destroy(model);

  return result;
}


//' Call POS Tagger via `lapply` and return a list of data.frame
//'
//' @param text Character vector.
//' @param sys_dic String scalar.
//' @param user_dic String scalar.
//' @return list of data.frame.
//'
//' @name posApplyDFRcpp
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
List posApplyDFRcpp(StringVector text, std::string sys_dic, std::string user_dic) {

  std::string args = "";
  if (sys_dic != "") {
    args.append(" -d ");
    args.append(sys_dic);
  }
  if (user_dic != "") {
    args.append(" -u ");
    args.append(user_dic);
  }

  mecab_model_t* model;
  mecab_t* tagger;
  mecab_lattice_t* lattice;
  const mecab_node_t* node;

  model = mecab_model_new2(args.c_str());
  if (!model) {
    Rcpp::Rcerr << "model is NULL" << std::endl;
    return R_NilValue;
  }
  tagger = mecab_model_new_tagger(model);
  lattice = mecab_model_new_lattice(model);

  std::function< DataFrame(String) > func = [&](String elem) {

    const std::string input = elem;

    mecab_lattice_set_sentence(lattice, input.c_str());
    mecab_parse_lattice(tagger, lattice);
    node = mecab_lattice_get_bos_node(lattice);

    std::vector<std::string> surface, feature;

    for (; node; node = node->next) {
      if (node->stat == MECAB_BOS_NODE)
        ;
      else if (node->stat == MECAB_EOS_NODE)
        ;
      else {
        surface.push_back(std::string(node->surface, node->length));
        feature.push_back(std::string(node->feature));
      }
    }

    return DataFrame::create(
      Named("Surface") = surface,
      Named("Feature") = feature
    );
  };

  const List result = lapply(text, func);

  mecab_destroy(tagger);
  mecab_lattice_destroy(lattice);
  mecab_model_destroy(model);

  return result;
}


//' Call POS Tagger via loop and return a data.frame
//'
//' @param text Character vector.
//' @param sys_dic String scalar.
//' @param user_dic String scalar.
//' @return data.frame.
//'
//' @name posLoopDFRcpp
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
DataFrame posLoopDFRcpp(StringVector text, std::string sys_dic, std::string user_dic) {

  std::string args = "";
  if (sys_dic != "") {
    args.append(" -d ");
    args.append(sys_dic);
  }
  if (user_dic != "") {
    args.append(" -u ");
    args.append(user_dic);
  }

  // lattice model
  mecab_model_t* model;
  mecab_t* tagger;
  mecab_lattice_t* lattice;
  const mecab_node_t* node;

  // create model
  model = mecab_model_new2(args.c_str());
  if (!model) {
    Rcerr << "model is NULL" << std::endl;
    return R_NilValue;
  }

  tagger = mecab_model_new_tagger(model);
  lattice = mecab_model_new_lattice(model);

  StringVector::iterator it;

  StringVector doc_id;
  IntegerVector sentence_id;
  IntegerVector token_id;
  StringVector token;
  StringVector pos;
  StringVector subtype;
  StringVector analytic;

  String doc_id_t;
  String token_t;
  String pos_t;
  String subtype_t;
  String analytic_t;

  int doc_number = 0;
  int sentence_number = 1;
  int token_number = 1;

  StringVector text_names;
  bool b = text.hasAttribute("name");
  if (b == TRUE) {
    text_names = text.names();
  }

  for (it = text.begin(); it != text.end(); ++it) {

    mecab_lattice_set_sentence(lattice, as<const char*>(*it));
    mecab_parse_lattice(tagger, lattice);
    node = mecab_lattice_get_bos_node(lattice);

    for (; node; node = node->next) {
      if (node->stat == MECAB_BOS_NODE)
        ;
      else if (node->stat == MECAB_EOS_NODE)
        ;
      else {
        std::vector<std::string> features;
        boost::split(features, node->feature, boost::is_any_of(","));

        token_t = std::string(node->surface).substr(0, node->length);
        pos_t = features[0];
        subtype_t = features[1];
        // For parsing unk-feature when using Japanese MeCab and IPA-dict.
        if (features.size() > 7) {
          analytic_t = features[7];
        } else {
          analytic_t = "*";
        }

        // if (subtype_t == "*") {
        //   subtype_t = "";
        // }
        // if (analytic_t == "*") {
        //   analytic_t = "";
        // }

        token_t.set_encoding(CE_UTF8);
        pos_t.set_encoding(CE_UTF8);
        subtype_t.set_encoding(CE_UTF8);
        analytic_t.set_encoding(CE_UTF8);

        // append token, pos, and subtype
        token.push_back(token_t);
        pos.push_back(pos_t);
        subtype.push_back(subtype_t);
        analytic.push_back(analytic_t);

        token_id.push_back(token_number);
        token_number++;

        // append sentence_id and token_id
        sentence_id.push_back(sentence_number);
        if (token_t == "." or token_t == "。") {
          sentence_number++;
          token_number = 1;
        }

        // append doc_id
        if (b == TRUE) {
          doc_id_t = text_names[doc_number];
          doc_id_t.set_encoding(CE_UTF8);
          doc_id.push_back(doc_id_t);
        } else {
          doc_id.push_back(std::to_string(doc_number + 1));
        }
      }
    }
    sentence_number = 1;
    token_number = 1;
    doc_number++;
  }

  mecab_destroy(tagger);
  mecab_lattice_destroy(lattice);
  mecab_model_destroy(model);

  return DataFrame::create(
    _["doc_id"] = doc_id,
    _["sentence_id"] = sentence_id,
    _["token_id"] = token_id,
    _["token"] = token,
    _["pos"] = pos,
    _["subtype"] = subtype,
    _["analytic"] = analytic
  );
}

