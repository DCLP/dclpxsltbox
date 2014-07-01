#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
test xslt regression for the dclp project
"""

import argparse
import csv
from functools import wraps
import hashlib
import logging
import os
import re
import subprocess
import sys
import traceback

DEFAULTLOGLEVEL = logging.WARNING

def arglogger(func):
    """
    decorator to log argument calls to functions
    """
    @wraps(func)
    def inner(*args, **kwargs): 
        logger = logging.getLogger(func.__name__)
        logger.debug("called with arguments: %s, %s" % (args, kwargs))
        return func(*args, **kwargs) 
    return inner    


@arglogger
def hash_file(filename):
   """"This function returns the SHA-1 hash
   of the file passed into it"""

   # code from http://www.programiz.com/python-programming/examples/hash-file

   # make a hash object
   h = hashlib.sha1()

   # open file for reading in binary mode
   with open(filename,'rb') as file:

       # loop till the end of the file
       chunk = 0
       while chunk != b'':
           # read only 1024 bytes at a time
           chunk = file.read(1024)
           h.update(chunk)

   # return the hex representation of digest
   return h.hexdigest()

@arglogger
def main (args):
    """
    main functions
    """
    logger = logging.getLogger()
    log_level = DEFAULTLOGLEVEL
    if args.loglevel is not None:
        args_log_level = re.sub('\s+', '', args.loglevel.strip().upper())
        try:
            log_level = getattr(logger, args_log_level)
        except AttributeError:
            logger.error("command line option to set log_level failed because '%s' is not a valid level name; using %s" % (args_log_level, log_level_name))
    elif args.veryverbose:
        log_level = logging.DEBUG
    elif args.verbose:
        log_level = logging.INFO
    log_level_name = logging.getLevelName(log_level)
    logger.setLevel(log_level)
    if log_level != DEFAULTLOGLEVEL:
        logger.warning("logging level changed to %s via command line option" % log_level_name)
    else:
        logger.info("using default logging level: %s" % log_level_name)
    logger.debug("command line: '%s'" % ' '.join(sys.argv))

    script_path = os.path.realpath(__file__)
    logger.debug("script path is '%s'" % script_path)

    script_dir, script_name = os.path.split(script_path)
    logger.debug("script dir is '%s'" % script_dir)

    project_dir = os.path.abspath(os.path.join(script_dir, '..', '..'))
    logger.debug("project dir is '%s'" % project_dir)

    data_path = os.path.join(project_dir, 'idp.data')
    if not os.path.isdir(data_path):
        emsg = "%s is not a directory" % data_path
        logger.fatal(emsg)
        raise IOError(emsg)        
    logger.debug("data path is '%s'" % data_path)

    navigator_path = os.path.join(project_dir, 'navigator')
    if not os.path.isdir(navigator_path):
        emsg = "%s is not a directory" % navigator_path
        logger.fatal(emsg)
        raise IOError(emsg)        
    logger.debug("navigator path is '%s'" % navigator_path)

    xslt_file_path = os.path.join(navigator_path, 'pn-xslt', 'MakeHTML.xsl')
    if not os.path.isfile(xslt_file_path):
        emsg = "%s is not a file" % xslt_file_path
        logger.fatal(emsg)
        raise IOError(emsg)        
    logger.debug("xslt file path is '%s'" % xslt_file_path)

    output_path = os.path.join(script_dir, 'output')
    if not os.path.isdir(output_path):
        os.makedirs(output_path)
        logger.info("created test output directory at '%s'" % output_path)
    else:
        logger.debug("output path is '%s'" % output_path)

    candidate_file_path = os.path.join(script_dir, 'data', 'regression_candidates.csv')
    logger.debug("candidate file path is '%s'" % candidate_file_path)

    candidates = csv.DictReader(open(candidate_file_path, 'rb'))
    for candidate in candidates:
        candidate_collection = candidate['collection_id']
        candidate_relative_file_path = os.path.normpath(candidate['idpdata_relative_path'])
        candidate_file_path = os.path.join(data_path, candidate_relative_file_path)
        if not os.path.isfile(candidate_file_path):
            emsg = "%s is not a file" % candidate_file_path
            logger.fatal(emsg)
            raise IOError(emsg)
        logger.debug("candidate file path is '%s'" % candidate_file_path)
        candidate_relative_path, candidate_filename = os.path.split(candidate_relative_file_path)
        logger.debug("candidate_filename is '%s'" % candidate_filename)
        candidate_filename, candidate_extension = os.path.splitext(candidate_filename)
        logger.debug("candidate filename is '%s'" % candidate_filename)
        logger.debug("candidate filename extension is '%s'" % candidate_extension)
        output_file_path = os.path.join(output_path, candidate_collection.lower(), candidate_filename+'.html')
        sha_file_path = os.path.join(output_path, candidate_collection.lower(), candidate_filename+'.sha')
        if os.name == 'posix':
            cmd = ['saxon', '-xsl:%s' % xslt_file_path, '-o:%s' % output_file_path, '-s:%s' % candidate_file_path, 'collection="%s"' % candidate_collection, 'analytics="no"', 'cssbase="/css"', 'jsbase="/js"' ]
            logger.debug(' '.join(cmd))
            subprocess.call(' '.join(cmd), shell=True)       
        else:
            # handle it on pc
            pass

        sha_file = open(sha_file_path, 'r')
        prev_sha = sha_file.read()
        sha_file.close()
        logger.debug("previous sha is '%s'" % prev_sha)

        prev_sha_file_path = sha_file_path+'.prev'
        os.rename(sha_file_path, prev_sha_file_path)

        output_sha = hash_file(output_file_path)
        sha_file = open(sha_file_path, 'w')
        sha_file.write(output_sha)
        sha_file.close()
        logger.debug("output sha is '%s'" % output_sha)

        if prev_sha != output_sha:
            logger.critical("probable regression bug detected: checksum of newly-created file %s does not match checksum from previous run" % output_file_path)


if __name__ == "__main__":
    log_level = DEFAULTLOGLEVEL
    log_level_name = logging.getLevelName(log_level)
    logging.basicConfig(level=log_level)

    try:
        parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
        parser.add_argument ("-l", "--loglevel", type=str, help="desired logging level (case-insensitive string: DEBUG, INFO, WARNING, ERROR" )
        parser.add_argument ("-v", "--verbose", action="store_true", default=False, help="verbose output (logging level == INFO")
        parser.add_argument ("-vv", "--veryverbose", action="store_true", default=False, help="very verbose output (logging level == DEBUG")
        # example positional argument:
        # parser.add_argument('integers', metavar='N', type=int, nargs='+', help='an integer for the accumulator')
        args = parser.parse_args()
        main(args)
        sys.exit(0)
    except KeyboardInterrupt, e: # Ctrl-C
        raise e
    except SystemExit, e: # sys.exit()
        raise e
    except Exception, e:
        print "ERROR, UNEXPECTED EXCEPTION"
        print str(e)
        traceback.print_exc()
        os._exit(1)
