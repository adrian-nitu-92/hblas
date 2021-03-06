{-# LANGUAGE ScopedTypeVariables, DataKinds, CPP #-}
import Numerical.HBLAS.BLAS.FFI
import Numerical.HBLAS.BLAS
import Numerical.HBLAS.MatrixTypes 
import Data.Vector.Storable.Mutable as M 
import qualified Data.Vector.Storable as S 

main :: IO ()
main = do
  -- Just test that the symbol resolves
  --openblas_set_num_threads_unsafe 7  
  v  :: IOVector Double <- M.replicate 10 1.0
  res <- unsafeWith v (\ptr-> cblas_ddot_unsafe 10 ptr 1   ptr 1) 
#if defined(__GLASGOW_HASKELL_) && (__GLASGOW_HASKELL__ <= 704)
  --this makes 7.4 panic! 
  (leftMat :: IODenseMatrix Row Float) <-  generateMutableDenseMatrix SRow (5,5) (\_ -> 1.0 ::Float )
  (rightMat :: IODenseMatrix Row Float) <-  generateMutableDenseMatrix SRow (5,5) (\_ -> 1.0 ::Float )
  (resMat :: IODenseMatrix Row Float) <-  generateMutableDenseMatrix SRow (5,5) (\_ -> 1.0 ::Float )
  sgemm NoTranspose NoTranspose 1.0 1.0 leftMat rightMat resMat
  --(MutableDenseMatrix _ _ _ _ buff) <- return resMat 
  theRestMat <- unsafeFreezeDenseMatrix resMat
  putStrLn $ show theRestMat
#endif
--DenseMatrix SRow  5 5 5(fromList [11.0,11.0,11.0,11.0,11.0,11.0,11.0,11.0,11.0,11.0,51.0,51.0,51.0,51.0,51.0,51.0,51.0,51.0,51.0,51.0,251.0,251.0,251.0,251.0,251.0])
-- THAT IS WRONG 
--Need to figure what whats going on here   

  putStrLn $ show res 
  putStrLn "it works!"
  