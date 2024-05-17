import React, { useEffect, useState } from 'react'
import { MoviesWrapper } from '../movies.modules'
import axios from "axios";
import { epDiscover, epSearch } from '../endpoints';

interface MovieDto {

    id:number;
    title: string;
    release_date: string;
    poster_path: string;
}

const Movies = () => {

    const [showMovies, setShowMovies] = useState<MovieDto[]>([]);
    const [searchQuery, setSearchQuery] = useState("");
    const [currentPage, setCurrentPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);

    

        const fetchMovies = async () => {
            try{
                const endpoint = searchQuery ? epSearch : epDiscover;
                const response = await axios.get(endpoint, {
                    params: {
                        query: searchQuery,                        
                        page: currentPage
                    }
                });
                const {results, total_pages} = response.data;
                setShowMovies(results);
                setTotalPages(total_pages);
                console.log(results);
            } catch (error) {
                console.error("something went wrong", error);
            }
        };
        useEffect(() => {
        fetchMovies();
    });

    const navigatePages = (direction: "prev" | "next") => {

        if(direction === "prev" && currentPage > 1){
            setCurrentPage((prev) => prev -1)
        } else if(direction === "next" && currentPage < totalPages){
            setCurrentPage((next) => next +1)
        }
    }

    const showAll = () => {
        fetchMovies();
        setCurrentPage(1);
    }

  return (
    <MoviesWrapper>

        <h1>TMDB Code Challenge</h1>
        <div className="searchBar">
            <input type='text' value={searchQuery} onChange={(e) => {
                setSearchQuery(e.target.value);
            }}/>
            <button onClick={showAll}>Show All</button>
        </div>
        <div className="movieCard">
        {showMovies.map( (items) => {
            return (
                <div className="movie" key={items.id}>
                    <div className="movieImg">
                        <img src={`https://image.tmdb.org/t/p/w200${items.poster_path}`} alt='img' />
                    </div>
                    <div className="movieInfo">
                        <h4>{items.title}</h4>
                        <p>{items.release_date}</p>
                    </div>
                </div>
            )
        })}
        </div>
        <div className="buttons">
            {currentPage > 1 && (
                <button className='btnPrev' onClick={() => navigatePages("prev")}>Back</button>
            )}
            <p>Page | {currentPage}</p>
            {currentPage < totalPages && (
                <button className='btnNext' onClick={() => navigatePages("next")}>Next</button>
            )}
        </div>
    </MoviesWrapper>
  )
}

export default Movies