{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE UndecidableInstances #-}

module Control.Distributed.Spark.SQL.Context where

import Control.Distributed.Spark.Context
import Language.Java

newtype SQLContext = SQLContext (J ('Class "org.apache.spark.sql.SQLContext"))
  deriving Coercible

newSQLContext :: SparkContext -> IO SQLContext
newSQLContext sc = new [coerce sc]

getOrCreateSQLContext :: SparkContext -> IO SQLContext
getOrCreateSQLContext jsc = do
  sc :: J ('Class "org.apache.spark.SparkContext") <- call jsc "sc" []
  callStatic (classOf (undefined :: SQLContext))
             "getOrCreate"
             [coerce sc]
