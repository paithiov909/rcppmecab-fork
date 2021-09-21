// [[Rcpp::plugins(cpp11)]]
// [[Rcpp::depends(RcppThread, BH)]]

#define R_NO_REMAP
#define RCPPTHREAD_OVERRIDE_THREAD 1

#include <iostream>
#include <sstream>
#include <Rcpp.h>
#include <RcppThread.h>
#include <boost/algorithm/string.hpp>
#include <boost/tuple/tuple.hpp>
#include "../inst/include/mecab.h"

using namespace Rcpp;

//' Call tagger inside a loop and return a list of named character vectors.
//'
//' @param text Character vector.
//' @param sys_dic String scalar.
//' @param user_dic String scalar.
//' @return list of named character vectors.
//'
//' @name posLoopRcpp
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
List posLoopRcpp(CharacterVector text, std::string sys_dic, std::string user_dic) {

  // args
  std::vector<std::string> args;
  args.push_back("mecab");
  if (sys_dic != "") {
    args.push_back("-d");
    args.push_back(sys_dic);
  }
  if (user_dic != "") {
    args.push_back("-u");
    args.push_back(user_dic);
  }
  const char* delim = " ";
  std::ostringstream os;
  std::copy(args.begin(), args.end(), std::ostream_iterator<std::string>(os, delim));
  std::string argv = os.str();

  // lattice model
  mecab_model_t* model;
  mecab_t* tagger;
  mecab_lattice_t* lattice;
  const mecab_node_t* node;

  // create model
  model = mecab_model_new2(argv.c_str());
  if (!model) {
    Rcerr << "model is NULL" << std::endl;
    return R_NilValue;
  }
  tagger = mecab_model_new_tagger(model);
  lattice = mecab_model_new_lattice(model);

  // reserve a list and assign named charactor vectors.
  List result(text.size());
  std::string input;
  CharacterVector token_t;
  CharacterVector tag_t;

  for (R_len_t i = 0; i < result.size(); ++i) {

    std::vector< std::string > token;
    std::vector< std::string > tag;

    input = as<std::string>(text[i]);
    mecab_lattice_set_sentence(lattice, input.c_str());
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
        token.push_back(std::string(node->surface).substr(0, node->length));
        tag.push_back(features[0]);
      }
    }
    token_t = wrap(token);
    tag_t = wrap(tag);
    token_t.names() = tag_t;
    result[i] = token_t;
  };

  // clean
  mecab_destroy(tagger);
  mecab_lattice_destroy(lattice);
  mecab_model_destroy(model);

  return result;
}

//' Call tagger inside a loop and return a named list.
//'
//' @param text Character vector.
//' @param sys_dic String scalar.
//' @param user_dic String scalar.
//' @return named list.
//'
//' @name posLoopJoinRcpp
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
List posLoopJoinRcpp(StringVector text, std::string sys_dic, std::string user_dic) {

  std::vector<std::string> args;
  args.push_back("mecab");
  if (sys_dic != "") {
    args.push_back("-d");
    args.push_back(sys_dic);
  }
  if (user_dic != "") {
    args.push_back("-u");
    args.push_back(user_dic);
  }
  const char* delim = " ";
  std::ostringstream os;
  std::copy(args.begin(), args.end(), std::ostream_iterator<std::string>(os, delim));
  std::string argv = os.str();

  // lattice model
  mecab_model_t* model;
  mecab_t* tagger;
  mecab_lattice_t* lattice;
  const mecab_node_t* node;

  // create model
  model = mecab_model_new2(argv.c_str());
  if (!model) {
    Rcerr << "model is NULL" << std::endl;
    return R_NilValue;
  }

  tagger = mecab_model_new_tagger(model);
  lattice = mecab_model_new_lattice(model);

  // reserve a list and assign charactor vectors.
  List result(text.size());
  std::string input;
  CharacterVector token_t;

  for (R_len_t i = 0; i < result.size(); ++i) {

    std::vector< std::string > token;

    input = as<std::string>(text[i]);
    mecab_lattice_set_sentence(lattice, input.c_str());
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
        token.push_back(
          std::string(node->surface).substr(0, node->length) + "/" + features[0]);
      }
    }
    token_t = wrap(token);
    result[i] = token_t;
  };

  // clean
  mecab_destroy(tagger);
  mecab_lattice_destroy(lattice);
  mecab_model_destroy(model);

  return result;
}

//' Call tagger inside a loop and return a data.frame
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

  // args
  std::vector<std::string> args;
  args.push_back("mecab");
  if (sys_dic != "") {
    args.push_back("-d");
    args.push_back(sys_dic);
  }
  if (user_dic != "") {
    args.push_back("-u");
    args.push_back(user_dic);
  }
  const char* delim = " ";
  std::ostringstream os;
  std::copy(args.begin(), args.end(), std::ostream_iterator<std::string>(os, delim));
  std::string argv = os.str();

  // lattice model
  mecab_model_t* model;
  mecab_t* tagger;
  mecab_lattice_t* lattice;
  const mecab_node_t* node;

  // create model
  model = mecab_model_new2(argv.c_str());
  if (!model) {
    Rcerr << "model is NULL" << std::endl;
    return R_NilValue;
  }

  tagger = mecab_model_new_tagger(model);
  lattice = mecab_model_new_lattice(model);

  // In general, standard C++ data structure is much faster
  // than Rcpp vector to use 'push_back'.
  // See also "Chapter 30 Standard C++ data structures and algorithms | Rcpp for everyone"
  // for details of this topic.
  std::vector< std::vector < boost::tuple< std::string, std::string, std::string, std::string > > > results(text.size());
  std::vector< int > sentence_id;
  std::vector< int > token_id;
  std::vector< std::string > token;
  std::vector< std::string > pos;
  std::vector< std::string > subtype;
  std::vector< std::string > analytic;

  int sentence_number = 0;
  int token_number = 1;

  for (R_len_t i = 0; i < text.size(); ++i) {

    std::vector< boost::tuple< std::string, std::string, std::string, std::string > > parsed;
    std::string input = as<std::string>(text[i]);
    mecab_lattice_set_sentence(lattice, input.c_str());
    mecab_parse_lattice(tagger, lattice);

    // reserve size of lattice (number of tokens).
    const size_t len = mecab_lattice_get_size(lattice);
    results[i].reserve(len);

    node = mecab_lattice_get_bos_node(lattice);

    for (; node; node = node->next) {
      if (node->stat == MECAB_BOS_NODE)
        ;
      else if (node->stat == MECAB_EOS_NODE)
        ;
      else {
        std::string parsed_morph = std::string(node->surface).substr(0, node->length);
        std::vector<std::string> features;
        boost::split(features, node->feature, boost::is_any_of(","));

        std::string unk_t;
        // For parsing unk-feature when using Japanese MeCab and IPA-dict.
        if (features.size() > 7) {
          unk_t = features[7];
        } else {
          unk_t = "*";
        }

        parsed.push_back(boost::make_tuple(
            parsed_morph,
            features[0],
            features[1],
            unk_t
        ));
      }
    }
    results[i] = parsed;
  }

  // clean
  mecab_destroy(tagger);
  mecab_lattice_destroy(lattice);
  mecab_model_destroy(model);

  // make columns for result data.frame.
  for (size_t k = 0; k < results.size(); ++k) {
    // check user interrupt (Ctrl+C).
    if (k % 1000 == 0) checkUserInterrupt();

    std::vector < boost::tuple< std::string, std::string, std::string, std::string > >::const_iterator l;
    for (l = results[k].begin(); l != results[k].end(); ++l) {

      token.push_back(boost::tuples::get<0>(*l));
      pos.push_back(boost::tuples::get<1>(*l));
      subtype.push_back(boost::tuples::get<2>(*l));
      analytic.push_back(boost::tuples::get<3>(*l));

      token_id.push_back(token_number);
      token_number++;

      sentence_id.push_back(sentence_number + 1);
    }
    token_number = 1;
    sentence_number++;
  }

  return DataFrame::create(
    _["sentence_id"] = sentence_id,
    _["token_id"] = token_id,
    _["token"] = token,
    _["pos"] = pos,
    _["subtype"] = subtype,
    _["analytic"] = analytic,
    _["stringsAsFactors"] = false);
}
