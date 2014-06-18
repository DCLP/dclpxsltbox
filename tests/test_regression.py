#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
test xslt regression for the dclp project
"""

import argparse
import csv
from functools import wraps
import logging
import os
import re
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
def main (args):
    """
    main functions
    """
    logger = logging.getLogger()
    log_level = DEFAULTLOGLEVEL
    if args.loglevel is not None:
        args_log_level = re.sub('\s+', '', args.loglevel.strip().upper())
        try:
            log_level = getattr(logging, args_log_level)
        except AttributeError:
            logging.error("command line option to set log_level failed because '%s' is not a valid level name; using %s" % (args_log_level, log_level_name))
    elif args.veryverbose:
        log_level = logging.DEBUG
    elif args.verbose:
        log_level = logging.INFO
    log_level_name = logging.getLevelName(log_level)
    logger.setLevel(log_level)
    if log_level != DEFAULTLOGLEVEL:
        logging.warning("logging level changed to %s via command line option" % log_level_name)
    else:
        logging.info("using default logging level: %s" % log_level_name)
    logging.debug("command line: '%s'" % ' '.join(sys.argv))

    script_path = os.path.realpath(__file__)
    logger.info("script path is '%s'" % script_path)
    dir_name, script_name = os.path.split(script_path)
    infn = os.path.join(dir_name, 'data', 'regression_candidates.csv')
    candidates = csv.DictReader(open(infn, 'rb'))
    for candidate in candidates:
        # check for regression
        logger.info("file to check for regression: '%s' (%s)" % (candidate['idpdata_relative_path'], candidate['collection_id']))




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
